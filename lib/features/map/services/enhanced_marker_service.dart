import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../providers/map_state_provider.dart';
import '../../auth/providers/auth_provider.dart';

class EnhancedMarkerService {
  final WidgetRef ref;
  Timer? _markerHealthTimer;
  bool _mounted = true;
  
  // Control de marcadores múltiples
  Symbol? _currentMarker;
  Line? _markerCircle;
  Fill? _markerFill;
  DateTime? _lastMarkerUpdate;
  static const Duration _markerUpdateThrottle = Duration(milliseconds: 500);

  EnhancedMarkerService(this.ref);

  void dispose() {
    _mounted = false;
    _markerHealthTimer?.cancel();
  }

  // ========== UTILITY METHODS ==========
  
  Future<Uint8List?> _loadImageFromAssets(String path) async {
    try {
      final ByteData data = await rootBundle.load(path);
      return data.buffer.asUint8List();
    } catch (e) {
      print('❌ Error cargando imagen desde assets: $e');
      return null;
    }
  }

  // ========== MARKER MANAGEMENT ==========
  
  Future<void> updateMarkerPosition(MapLibreMapController controller, Position position) async {
    if (!_mounted) return;

    final now = DateTime.now();
    if (_lastMarkerUpdate != null && 
        now.difference(_lastMarkerUpdate!) < _markerUpdateThrottle) {
      return;
    }
    _lastMarkerUpdate = now;

    await _updateMarkerLocation(controller, position);
  }

  Future<void> _updateMarkerLocation(MapLibreMapController controller, Position position) async {
    final location = LatLng(position.latitude, position.longitude);
    
    try {
      if (_currentMarker == null && _markerCircle == null && _markerFill == null) {
        await _createMultiLayerMarker(controller, location);
        return;
      }

      await _updateExistingMarkers(controller, location);
      print('🎯 Marcadores actualizados: ${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}');

    } catch (e) {
      print('❌ Error actualizando marcadores: $e');
      await _recreateAllMarkers(controller, location);
    }
  }

  Future<void> _createMultiLayerMarker(MapLibreMapController controller, LatLng location) async {
    print('🎨 Creando marcador...');
    
    final user = ref.read(userProvider);
    
    // Para CHOFERES: usar icono de bus
    if (user?.esMicrero == true) {
      if (await _createBusIconMarker(controller, location)) {
        print('✅ Marcador de bus (chofer) creado sin círculos');
        ref.read(mapStateProvider.notifier).setCurrentLocationSymbol(_currentMarker);
        return;
      }
    }
    // Para CLIENTES: usar icono de persona
    else if (user?.esCliente == true) {
      if (await _createClientIconMarker(controller, location)) {
        print('✅ Marcador de cliente creado sin círculos');
        ref.read(mapStateProvider.notifier).setCurrentLocationSymbol(_currentMarker);
        return;
      }
    }
    
    // Si no se pudo crear el icono específico, usar fallbacks con círculos
    print('📍 Creando marcador de fallback con círculos...');
    await _createBackgroundCircle(controller, location);
    await _createCircleBorder(controller, location);
    await _createFallbackSymbol(controller, location);
    
    ref.read(mapStateProvider.notifier).setCurrentLocationSymbol(_currentMarker);
  }

  Future<void> _createBackgroundCircle(MapLibreMapController controller, LatLng location) async {
    try {
      final circlePoints = _generateCirclePoints(location, 0.0002);
      
      _markerFill = await controller.addFill(FillOptions(
        geometry: [circlePoints],
        fillColor: "#FF0000",
        fillOpacity: 0.3,
      ));
      
      print('✅ Círculo de fondo creado');
    } catch (e) {
      print('⚠️ Error creando círculo de fondo: $e');
    }
  }

  Future<void> _createCircleBorder(MapLibreMapController controller, LatLng location) async {
    try {
      final circlePoints = _generateCirclePoints(location, 0.0002);
      
      _markerCircle = await controller.addLine(LineOptions(
        geometry: circlePoints,
        lineColor: "#FF0000",
        lineWidth: 4.0,
        lineOpacity: 1.0,
      ));
      
      print('✅ Borde del círculo creado');
    } catch (e) {
      print('⚠️ Error creando borde: $e');
    }
  }

  Future<void> _createFallbackSymbol(MapLibreMapController controller, LatLng location) async {
    if (await _createEmojiMarker(controller, location)) return;
    if (await _createTextMarker(controller, location)) return;
    await _createSimplePointMarker(controller, location);
  }

  Future<bool> _createBusIconMarker(MapLibreMapController controller, LatLng location) async {
    try {
      // Primero cargar la imagen desde assets
      final imageBytes = await _loadImageFromAssets('assets/images/bus-marker.png');
      if (imageBytes == null) {
        print('⚠️ No se pudo cargar la imagen bus-marker.png');
        return false;
      }
      
      // Agregar la imagen al mapa
      await controller.addImage('bus-marker', imageBytes);
      
      _currentMarker = await controller.addSymbol(SymbolOptions(
        geometry: location,
        iconImage: 'bus-marker',
        iconSize: 1.0, // Tamaño más grande para mejor visibilidad
        iconAnchor: 'bottom', // Anclar por la parte inferior
        iconOffset: const Offset(0, 0),
      ));

      print('✅ Marcador con ícono de bus creado (enhanced)');
      return true;

    } catch (e) {
      print('⚠️ Fallo marcador con ícono de bus (enhanced): $e');
      return false;
    }
  }

  Future<bool> _createClientIconMarker(MapLibreMapController controller, LatLng location) async {
    try {
      _currentMarker = await controller.addSymbol(SymbolOptions(
        geometry: location,
        textField: '📍', // Icono de ubicación para cliente
        textColor: '#2196F3', // Azul para cliente
        textSize: 32.0,
        textHaloColor: '#FFFFFF',
        textHaloWidth: 3.0,
        textOffset: const Offset(0, 0),
        textAnchor: 'center',
      ));

      print('✅ Marcador de cliente creado (enhanced)');
      return true;

    } catch (e) {
      print('⚠️ Fallo marcador de cliente (enhanced): $e');
      return false;
    }
  }

  Future<bool> _createEmojiMarker(MapLibreMapController controller, LatLng location) async {
    try {
      _currentMarker = await controller.addSymbol(SymbolOptions(
        geometry: location,
        textField: '🚌',
        textColor: '#FFFFFF',
        textSize: 32.0,
        textHaloColor: '#FF0000',
        textHaloWidth: 8.0,
        textOffset: const Offset(0, 0),
        textAnchor: 'center',
      ));

      print('✅ Marcador emoji creado');
      return true;

    } catch (e) {
      print('⚠️ Fallo marcador emoji: $e');
      return false;
    }
  }

  Future<bool> _createTextMarker(MapLibreMapController controller, LatLng location) async {
    try {
      _currentMarker = await controller.addSymbol(SymbolOptions(
        geometry: location,
        textField: 'MICRO',
        textColor: '#FFFFFF',
        textSize: 16.0,
        textHaloColor: '#FF0000',
        textHaloWidth: 4.0,
        textOffset: const Offset(0, 0),
        textAnchor: 'center',
      ));

      print('✅ Marcador texto creado');
      return true;

    } catch (e) {
      print('⚠️ Fallo marcador texto: $e');
      return false;
    }
  }

  Future<void> _createSimplePointMarker(MapLibreMapController controller, LatLng location) async {
    try {
      _currentMarker = await controller.addSymbol(SymbolOptions(
        geometry: location,
        textField: '●',
        textColor: '#FF0000',
        textSize: 24.0,
        textOffset: const Offset(0, 0),
        textAnchor: 'center',
      ));

      print('✅ Marcador punto simple creado');
    } catch (e) {
      print('❌ Error crítico creando punto simple: $e');
    }
  }

  Future<void> _updateExistingMarkers(MapLibreMapController controller, LatLng location) async {
    if (_markerFill != null) {
      try {
        final circlePoints = _generateCirclePoints(location, 0.0002);
        await controller.updateFill(_markerFill!, FillOptions(
          geometry: [circlePoints],
        ));
      } catch (e) {
        print('⚠️ Error actualizando fill: $e');
      }
    }

    if (_markerCircle != null) {
      try {
        final circlePoints = _generateCirclePoints(location, 0.0002);
        await controller.updateLine(_markerCircle!, LineOptions(
          geometry: circlePoints,
        ));
      } catch (e) {
        print('⚠️ Error actualizando línea: $e');
      }
    }

    if (_currentMarker != null) {
      try {
        await controller.updateSymbol(_currentMarker!, SymbolOptions(
          geometry: location,
        ));
      } catch (e) {
        print('⚠️ Error actualizando símbolo: $e');
      }
    }
  }

  List<LatLng> _generateCirclePoints(LatLng center, double radius) {
    final points = <LatLng>[];
    const int numPoints = 32;
    
    for (int i = 0; i <= numPoints; i++) {
      final angle = (i * 2 * pi) / numPoints;
      final lat = center.latitude + radius * cos(angle);
      final lng = center.longitude + radius * sin(angle);
      points.add(LatLng(lat, lng));
    }
    
    return points;
  }

  Future<void> _recreateAllMarkers(MapLibreMapController controller, LatLng location) async {
    await clearMarker(controller);
    await _createMultiLayerMarker(controller, location);
  }

  Future<void> clearMarker(MapLibreMapController? controller) async {
    if (controller == null) return;
    
    if (_markerFill != null) {
      try {
        await controller.removeFill(_markerFill!);
        print('🗑️ Fill removido');
      } catch (e) {
        print('⚠️ Error removiendo fill: $e');
      }
    }
    
    if (_markerCircle != null) {
      try {
        await controller.removeLine(_markerCircle!);
        print('🗑️ Line removido');
      } catch (e) {
        print('⚠️ Error removiendo line: $e');
      }
    }
    
    if (_currentMarker != null) {
      try {
        await controller.removeSymbol(_currentMarker!);
        print('🗑️ Symbol removido');
      } catch (e) {
        print('⚠️ Error removiendo symbol: $e');
      }
    }
    
    _currentMarker = null;
    _markerCircle = null;
    _markerFill = null;
    ref.read(mapStateProvider.notifier).resetMarkerState();
  }

  // ========== MARKER HEALTH CHECK ==========
  
  void initializeMarkerHealthCheck(MapLibreMapController controller) {
    if (!_mounted) return;
    
    _markerHealthTimer?.cancel();
    _markerHealthTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!_mounted || !ref.read(mapStateProvider).isServiceActive) {
        timer.cancel();
        return;
      }
      
      await _checkMarkerHealth(controller);
    });
  }

  Future<void> _checkMarkerHealth(MapLibreMapController controller) async {
    final currentPosition = ref.read(mapStateProvider).currentPosition;
    if (currentPosition == null) return;

    if (_currentMarker == null && _markerCircle == null && _markerFill == null) {
      print('🔧 Health check: Recreando marcadores faltantes');
      final location = LatLng(currentPosition.latitude, currentPosition.longitude);
      await _createMultiLayerMarker(controller, location);
    }
  }

  // ========== CAMERA CONTROLS ==========
  
  Future<void> centerOnMarker(MapLibreMapController controller) async {
    final currentPosition = ref.read(mapStateProvider).currentPosition;
    if (currentPosition == null) return;

    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(currentPosition.latitude, currentPosition.longitude), 
        16.0
      ),
      duration: const Duration(milliseconds: 800),
    );
    
    ref.read(mapStateProvider.notifier).setFollowMicro(true);
  }

  Future<void> updateCameraIfFollowing(MapLibreMapController controller, Position position) async {
    final mapState = ref.read(mapStateProvider);
    if (!mapState.followMicro) return;

    try {
      await controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
        duration: const Duration(milliseconds: 500),
      );
    } catch (e) {
      print('⚠️ Error moviendo cámara: $e');
    }
  }
} 