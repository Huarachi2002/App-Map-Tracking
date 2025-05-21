import 'dart:async';
import 'package:app_map_tracking/features/auth/providers/auth_provider.dart';
import 'package:app_map_tracking/features/tracking/providers/tracking_provider.dart';
import 'package:app_map_tracking/services/background_tracking_service.dart';
import 'package:app_map_tracking/services/tracking_socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geolocator/geolocator.dart'; // Para solicitar permisos

import 'package:flutter_background_service/flutter_background_service.dart';

import '../../../common/utils.dart';
import '../../../common/widgets/app_drawer.dart';
import '../../../config/constants.dart';

import 'dart:io' show Platform;

class EmployeeMapPage extends StatelessWidget {
  const EmployeeMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Map();
  }
}

class Map extends ConsumerStatefulWidget {
  const Map({super.key});

  @override
  ConsumerState<Map> createState() => MapState();
}

class MapState extends ConsumerState<Map> {
  MapLibreMapController? _controller;
  final Future<String> styles = initStyle();
  final Completer<MapLibreMapController> mapController = Completer();
  bool canInteractWithMap = false;
  bool _imageLoaded = false;
  Symbol? currentLocationSymbol;
  StreamSubscription? _locationSubscription;

  // Variables para tracking en segundo plano
  final BackgroundTrackingService _backgroundService = BackgroundTrackingService();
  bool _isBackgroundTracking = false;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _initializeTracking();
    _checkBackgroundServiceStatus();
  }

  Future<void> _checkBackgroundServiceStatus() async {
    final service = FlutterBackgroundService();
    bool isRunning = await service.isRunning();

    setState(() {
      _isBackgroundTracking = isRunning;
    });
  }

  Future<void> _loadImages(MapLibreMapController controller) async {
    try {
      print("Cargando imagen del marcador...");
      final imageBytes = await _loadImageFromAsset("assets/images/bus-marker.png");
      print("Bytes de imagen cargados: ${imageBytes.length}");
      
      // En caso de error con la imagen original, prueba una imagen más simple
      if (imageBytes.isEmpty) {
        print("Usando imagen simple de fallback");
        // Crear una imagen simple en memoria como fallback
        final size = 8;
        final bytes = Uint8List(size * size * 4);
        for (var i = 0; i < size * size; i++) {
          bytes[i * 4] = 255;      // R
          bytes[i * 4 + 1] = 0;    // G
          bytes[i * 4 + 2] = 0;    // B
          bytes[i * 4 + 3] = 255;  // A
        }
        await controller.addImage("bus-marker", bytes);
      } else {
        await controller.addImage("bus-marker", imageBytes);
      }
      _imageLoaded = true;
      print("Imagen cargada con éxito");
    } catch (e) {
      print("Error loading images: $e");
    }
  }

  Future<Uint8List> _loadImageFromAsset(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      return data.buffer.asUint8List();
    } catch (e) {
      print("Error loading asset: $e");
      // Retorna una imagen vacía para evitar errores
      return Uint8List(0);
    }
  }

  Future<void> _initializeTracking() async {
    try {
      
      final trackingService = ref.read(trackingServiceProvider);
      final user = ref.read(userProvider);

      if (user == null || user.empleado == null) {
        print("No hay un empleado autenticado o falta información");
        return;
      }

      final String idMicro = user.empleado!.id_micro;
      final String token = user.token;
      print("ID Micro: $idMicro");
      print("Token: $token");

      // Inicializar el servicio de background
      await _backgroundService.initializeService();

      // Guardar datos para el servicio en segundo plano
      await _backgroundService.storeServiceData(
          idMicro,
          token,
          baseUrlSocket
      );

      // Inicializar el socket para tracking en primer plano
      await trackingService.initSocket(
        baseUrlSocket,
        idMicro,
        token,
      );

      // Escuchar actualizaciones de ubicación
      trackingService.on(TrackingEventType.locationUpdate).listen((data) {
        _updateLocationOnMap(LatLng(data['latitud'], data['longitud']));
      });

      // Escuchar estado de conexión
      trackingService.on(TrackingEventType.connectionStatusChanged).listen((isConnected) {
        setState(() {
          _isConnected = isConnected;
        });
      });
    } catch (e) {
      print("Error initializing tracking: $e");
    }
  }

  Future<void> _toggleBackgroundTracking() async {
    if (_isBackgroundTracking) {
      // Detener el servicio en segundo plano
      _backgroundService.stopService();
    } else {
      // Verificar permiso de ubicación en segundo plano para Android
      if (Platform.isAndroid) {
        LocationPermission permission = await Geolocator.checkPermission();

        if (permission != LocationPermission.always) {
          // Solicitar permiso de ubicación en segundo plano
          permission = await Geolocator.requestPermission();

          if (permission != LocationPermission.always) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Se requiere permiso "Permitir siempre" para tracking en segundo plano'))
            );
            // Abrir configuración para que el usuario permita "Siempre"
            await Geolocator.openAppSettings();
            return;
          }
        }
      }

      // Iniciar el servicio en segundo plano
      await _backgroundService.startService();
    }

    // Actualizar el estado del servicio
    await _checkBackgroundServiceStatus();
  }

  Future<void> _updateLocationOnMap(LatLng location) async {
    try {
      if (!mapController.isCompleted || !_imageLoaded) return;
      
      final controller = await mapController.future;

      if (currentLocationSymbol != null) {
        await controller.removeSymbol(currentLocationSymbol!);
      }

      currentLocationSymbol = await controller.addSymbol(SymbolOptions(
        geometry: location,
        iconImage: "bus-marker",
        iconSize: 0.8,
      ));

      await controller.animateCamera(CameraUpdate.newLatLng(location));
    } catch (e) {
      print("Error updating location on map: $e");
    }
  }

  @override
  void dispose() {
    // Cancela la suscripción
    _locationSubscription?.cancel();
    
    // Dispone el controlador del mapa
    if (mapController.isCompleted) {
      mapController.future.then((controller) {
        controller.dispose();
      });
    }
    
    super.dispose();
  }

  static Future<String> initStyle() async {
    try {
      // iniciarSeguimiento();
      final file = await copyAssetToFile('assets/santa_cruz.mbtiles');
      String styleFile = await leerArchivoAssets('assets/maplibre/style.json');
      styleFile = styleFile.replaceAll('___FILE_URI___', 'mbtiles:///${file.path}');
      return styleFile;
    } catch (e) {
      print("Error initializing style: $e");
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Empleado'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // Indicador de estado de conexión
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              _isConnected ? Icons.wifi : Icons.wifi_off,
              color: _isConnected ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children:[
          FutureBuilder<String>(
              future: styles,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return MapLibreMap(
                    onMapCreated: (controller) {
                      _controller = controller;
                      mapController.complete(controller);
                    },
                    styleString: "$styleUrl?key=$apiKey",
                    // styleString: snapshot.data!,
                    initialCameraPosition: const CameraPosition(
                        zoom: 13.0, target: LatLng(-17.78314, -63.18084)),
                    trackCameraPosition: true,
                    minMaxZoomPreference: const MinMaxZoomPreference(5.0, 20.0),
                    onStyleLoadedCallback: () {
                      setState(() => canInteractWithMap = true);
                      if (_controller != null) {
                        _loadImages(_controller!);
                      }
                    },
                  );
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                return const Center(child: CircularProgressIndicator());
              }),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isBackgroundTracking
                          ? 'Tracking en Segundo Plano Activo'
                          : 'Tracking en Segundo Plano Inactivo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isBackgroundTracking ? Colors.green : Colors.grey,
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _toggleBackgroundTracking,
                      icon: Icon(_isBackgroundTracking ? Icons.stop : Icons.play_arrow),
                      label: Text(_isBackgroundTracking ? 'Detener' : 'Iniciar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isBackgroundTracking ? Colors.red : Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 48),
                      ),
                    ),
                    if (_isBackgroundTracking)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Tu ubicación se seguirá enviando incluso con la app cerrada',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          )
        ]


      ),

    );
  }
}
