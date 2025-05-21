import 'dart:async';
import 'package:app_map_tracking/features/auth/providers/auth_provider.dart';
import 'package:app_map_tracking/features/tracking/providers/tracking_provider.dart';
import 'package:app_map_tracking/services/tracking_socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../../common/utils.dart';
import '../../../common/widgets/app_drawer.dart';
import '../../../config/constants.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeTracking();
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
      await trackingService.initSocket(
        baseUrlSocket,
        idMicro,
        token,
      );

      trackingService.on(TrackingEventType.locationUpdate).listen((data) {
        _updateLocationOnMap(LatLng(data['latitud'], data['longitud']));
      });
    } catch (e) {
      print("Error initializing tracking: $e");
    }
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
    
    // Dispone el servicio de tracking
    // final trackingService = ref.read(trackingServiceProvider);
    // trackingService.dispose();
    
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
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<String>(
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
    );
  }
}
