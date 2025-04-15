import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../common/utils.dart';

const apiKey = "MzhKbzEOi3IDm2v3qyrm ";
const styleUrl = "https://api.maptiler.com/maps/streets-v2/style.json";

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Map();
  }
}

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State createState() => MapState();
}

class MapState extends State<Map> {
  final Future<String> styles = initStyle();
  final Completer<MapLibreMapController> mapController = Completer();
  bool canInteractWithMap = false;

  static Future<String> initStyle() async {
      final file = await copyAssetToFile('assets/santa_cruz.mbtiles',);
      String styleFile = await leerArchivoAssets('assets/maplibre/style.json');

      styleFile = styleFile
          .replaceAll('___FILE_URI___', 'mbtiles:///${file.path}');
          // .replaceAll('asset://maplibre/glyphs', 'file:///data/user/0/com.example.app_map_tracking/cache/sprites/sprite')
          // .replaceAll('asset://maplibre/sprites/sprite', 'file:///data/user/0/com.example.app_map_tracking/cache/sprites/sprite');

      return styleFile?? "";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder<String>(
          future: styles,
          builder: (context, snapshot){
            if (snapshot.hasData) {
              return MapLibreMap(
                onMapCreated: (controller) => mapController.complete(controller),
                // styleString: "$styleUrl?key=$apiKey",
                styleString: snapshot.data!,
                initialCameraPosition: const CameraPosition(zoom: 13.0, target: LatLng(-17.78314, -63.18084)),
                trackCameraPosition: true,
                minMaxZoomPreference: MinMaxZoomPreference(5.0, 20.0),
                onStyleLoadedCallback: () => setState(() => canInteractWithMap = true),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            return const Center(child: CircularProgressIndicator());
          }
      ),
    );
  }
}
