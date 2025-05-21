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

class ClientMapPage extends StatelessWidget {
  const ClientMapPage({super.key});

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
  Symbol? currentLocationSymbol;
  StreamSubscription? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _initializeTracking();
  }

  Future<void> _loadImages(MapLibreMapController controller) async {
    try {
      await controller.addImage(
        "bus-marker",
        await _loadImageFromAsset("assets/images/bus-marker.png"),
      );
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

      await trackingService.initSocket(
        baseUrl,
        'id_micro',
        'tu-token-jwt',
      );

      _locationSubscription = trackingService
          .on(TrackingEventType.locationUpdate)
          .listen((data) {
        _updateLocationOnMap(LatLng(data['latitud'], data['longitud']));
      });
    } catch (e) {
      print("Error initializing tracking: $e");
    }
  }

  Future<void> _updateLocationOnMap(LatLng location) async {
    try {
      if (!mapController.isCompleted) return;
      
      final controller = await mapController.future;

      if (currentLocationSymbol != null) {
        await controller.removeSymbol(currentLocationSymbol!);
      }

      currentLocationSymbol = await controller.addSymbol(SymbolOptions(
        geometry: location,
        iconImage: "bus-marker",
        iconSize: 1.5,
        iconOffset: const Offset(0, -20),
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

  // Future<void> _addPolyline() async {
  //   final line = {
  //     "type": "FeatureCollection",
  //     "features": [
  //       {
  //         "type": "Feature",
  //         "properties": {},
  //         "geometry": {
  //           "type": "LineString",
  //           "coordinates": [
  //             [-63.1836952, -17.783915211],
  //             [-63.1838899, -17.781858371],
  //           ]
  //         }
  //       }
  //     ]
  //   };

  //   _controller.addGeoJsonSource("line-source", line);

  //   _controller?.addLine(const LineOptions(
  //       geometry: [
  //         LatLng(-17.783915211, -63.1836952),
  //         LatLng(-17.781858371, -63.1838899),
  //       ],
  //       lineColor: "#ff0000",
  //       lineWidth: 3.0,
  //       lineOpacity: 0.5,
  //       draggable: true),);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Cliente'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<String>(
          future: styles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MapLibreMap(
                onMapCreated: (controller) {
                  mapController.complete(controller);
                  _loadImages(controller);
                },
                styleString: "$styleUrl?key=$apiKey",
                initialCameraPosition: const CameraPosition(
                    zoom: 13.0, target: LatLng(-17.78314, -63.18084)),
                trackCameraPosition: true,
                minMaxZoomPreference: const MinMaxZoomPreference(5.0, 20.0),
                onStyleLoadedCallback: () =>
                    setState(() => canInteractWithMap = true),
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
