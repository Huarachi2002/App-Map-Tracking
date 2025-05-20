import 'dart:async';
import 'package:app_map_tracking/features/auth/providers/auth_provider.dart';
import 'package:app_map_tracking/features/tracking/providers/tracking_provider.dart';
import 'package:app_map_tracking/services/tracking_socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../../common/utils.dart';
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
  final Future<String> styles = initStyle();
  final Completer<MapLibreMapController> mapController = Completer();
  bool canInteractWithMap = false;
  Symbol? currentLocationSymbol;

  @override
  void initState() {
    _initializeTracking();
    super.initState();
  }

  Future<void> _loadImages(MapLibreMapController controller) async {
    await controller.addImage("bus-marker",
        await _loadImageFromAsset("assets/images/bus-marker.png"));
  }

  Future<Uint8List> _loadImageFromAsset(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    return bytes;
  }

  Future<void> _initializeTracking() async {
    final trackingService = ref.read(trackingServiceProvider);
    final user = ref.read(currentUsuarioProvider);

    if (user == null || user.empleado == null) {
      print("No hay un empleado autenticado o falta información");
      return;
    }

    final String idMicro = user.empleado!.id_micro;
    final String token = user.token;
    print("ID Micro: $idMicro");
    print("Token: $token");
    await trackingService.initSocket(
      baseUrl,
      idMicro,
      token,
    );

    trackingService.on(TrackingEventType.locationUpdate).listen((data) {
      _updateLocationOnMap(LatLng(data['latitud'], data['longitud']));
    });
  }

  Future<void> _updateLocationOnMap(LatLng location) async {
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
  }

  @override
  void dispose() {
    ref.read(trackingServiceProvider).dispose();
    super.dispose();
  }

  static Future<String> initStyle() async {
    final file = await copyAssetToFile(
      'assets/santa_cruz.mbtiles',
    );
    String styleFile = await leerArchivoAssets('assets/maplibre/style.json');

    styleFile =
        styleFile.replaceAll('___FILE_URI___', 'mbtiles:///${file.path}');
    // .replaceAll('asset://maplibre/glyphs', 'file:///data/user/0/com.example.app_map_tracking/cache/sprites/sprite')
    // .replaceAll('asset://maplibre/sprites/sprite', 'file:///data/user/0/com.example.app_map_tracking/cache/sprites/sprite');

    return styleFile ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
          future: styles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MapLibreMap(
                onMapCreated: (controller) {
                  mapController.complete(controller);
                  _loadImages(controller);
                },
                // styleString: "$styleUrl?key=$apiKey",
                styleString: snapshot.data!,
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
