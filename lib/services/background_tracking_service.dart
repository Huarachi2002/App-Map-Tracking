import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'tracking_socket_service.dart';

// Canal de notificación para Android
const notificationChannelId = 'tracking_service';
const notificationId = 888;

class BackgroundTrackingService {
  static final BackgroundTrackingService _instance = BackgroundTrackingService._internal();
  factory BackgroundTrackingService() => _instance;
  BackgroundTrackingService._internal();

  // Para almacenar datos que el servicio necesitara
  Future<void> storeServiceData(String microId, String token, String serveUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tracking_micro_id', microId);
    await prefs.setString('tracking_token', token);
    await prefs.setString('tracking_serve_url', serveUrl);
    await prefs.setInt('tracking_interval', 5);
  }

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    // Configurar notificaciones para Android
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId,
      'Tracking Service',
      description: 'Canal de notificación para el servicio de seguimiento',
      importance: Importance.high,

    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: false,
          isForegroundMode: true,
          notificationChannelId: notificationChannelId,
          initialNotificationTitle: 'Servicio de Seguimiento',
          initialNotificationContent: 'El servicio de seguimiento está en ejecución',
          foregroundServiceNotificationId: notificationId,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        // onForeground: onStart,
        // onBackground: onIosBackground,
      ),
    );
  }

  // Iniciar el servicio
  Future<void> startService() async {
    final service = FlutterBackgroundService();
    await service.startService();
  }

  // Detener el servicio
  void stopService() async {
    final service = FlutterBackgroundService();
    service.invoke('stopService');
  }

  // Configurar el intervalo de actualización
  Future<void> setUpdateInterval(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tracking_interval', seconds);

    // Notificar al servicio que cambie el intervalo
    final service = FlutterBackgroundService();
    service.invoke('updateInterval', {'interval': seconds});
  }
}

// Función principal del servicio en segundo plano
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  // Si se ejecuta en Android, configurar como servicio en primer plano
  if(service is AndroidServiceInstance){
    service.on('setAsForeground').listen((event){
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  // Gestionar la detención del servicio
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Cargar configuración
  final prefs = await SharedPreferences.getInstance();
  final microId = prefs.getString('tracking_micro_id') ?? '';
  final token = prefs.getString('tracking_token') ?? '';
  final serverUrl = prefs.getString('tracking_server_url') ?? '';
  int updateInterval = prefs.getInt('tracking_interval') ?? 5;

  // Verificar que tenemos los datos necesarios
  if (microId.isEmpty || token.isEmpty || serverUrl.isEmpty) {
    print('Datos de configuración faltantes para el tracking en segundo plano');
    service.stopSelf();
    return;
  }

  // Inicializar socket
  final trackingService = TrackingSocketService();
  await trackingService.initSocket(serverUrl, microId, token);

  // Verificar permisos de ubicación en segundo plano
  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever ||
      (Platform.isAndroid && permission != LocationPermission.always)) {
    print('Permisos de ubicación en segundo plano no otorgados');
    service.stopSelf();
    return;
  }

  // Crear un timer que se ejecutará periódicamente
  Timer? timer;
  timer?.cancel();

  // Manejar cambios de intervalo
  service.on('updateInterval').listen((event) {
    if (event != null && event['interval'] != null) {
      updateInterval = event['interval'];
      // Reiniciar el timer con el nuevo intervalo
      timer?.cancel();
      timer = Timer.periodic(Duration(seconds: updateInterval), (timer) async {
        await _sendLocationUpdate(trackingService, service);
      });
    }
  });

  // Iniciar el timer
  timer = Timer.periodic(Duration(seconds: updateInterval), (timer) async {
    await _sendLocationUpdate(trackingService, service);
  });
}

Future<void> _sendLocationUpdate(TrackingSocketService trackingService, ServiceInstance service) async {
  try{
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    final trackingData = {
      'id_micro': await _getMicroId(),
      'latitud': position.latitude,
      'longitud': position.longitude,
      'altura': position.altitude,
      'precision': position.accuracy,
      'bateria': _getBatteryLevel(),
      'imei': _getDeviceId(), // Reemplazar con el IMEI real
      'fuente': 'app_flutter',
    };

    trackingService.sendLocationUpdate(trackingData);

    if(service is AndroidServiceInstance){
      service.setForegroundNotificationInfo(
          title: 'Tracking Activo',
          content: 'Ubicacion actualizada: ${position.latitude}, ${position.longitude}'
      );
    }

    // Notificar al servicio principal (opcional)
    service.invoke(
      'updateLocation',
      trackingData,
    );
  } catch (e) {
    print('Error al obtener o enviar ubicación: $e');
  }
}

Future<String> _getMicroId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('tracking_micro_id') ?? '';
}

Future<double> _getBatteryLevel() async {
  // Aquí deberías implementar la lectura real de la batería
  // Puedes usar un plugin como battery_plus
  return 100.0; // Valor por defecto
}

Future<String> _getDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor ?? 'unknown';
  }
  return 'unknown-device';
}