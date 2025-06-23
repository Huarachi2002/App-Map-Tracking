import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geolocator/geolocator.dart';

import '../../../data/models/parada_model.dart';
import '../../providers/parada_provider.dart';

import '../providers/map_state_provider.dart';
import '../../../data/repositories_impl/entidad_repository_impl.dart';
import '../../../data/repositories_impl/ruta_repository_impl.dart';
import '../../../domain/repositories/providers/entidad_repository_provider.dart';
import '../../../domain/repositories/providers/ruta_repository_provider.dart';
import '../../providers/entidad_provider.dart';
import '../../providers/ruta_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../auth/providers/auth_provider.dart';

class ClientMapController {
  final WidgetRef ref;
  final Completer<MapLibreMapController> mapController = Completer();
  bool _mounted = true;
  
  // NUEVO: Sistema offline-first para clientes
  Timer? _syncTimer;
  bool _hasInitializedOfflineData = false;

  bool get isCompleted => mapController.isCompleted;
  Future<MapLibreMapController> get future => mapController.future;
  
  Line? _routeLine;
  bool canInteractWithMap = false;
  
  // Control de marcadores para el cliente
  Symbol? _clientLocationMarker;
  bool _hasRouteFocused = false; // Para evitar enfoque constante
  
  // Control de marcadores de paradas (usando círculos reales como en enhanced_marker_service)
  final List<Fill> _paradaFills = [];
  final List<Line> _paradaCircles = [];
  List<ParadaModel> _currentParadas = [];
  
  // NUEVO: Cache para evitar recargas innecesarias
  String? _lastLoadedRutaId;
  bool _paradasLoadingInProgress = false;

  ClientMapController(this.ref) {
    _initializeOfflineFirstSystem();
  }

  // ========== INITIALIZATION ==========
  
  void onMapCreated(MapLibreMapController controller) {
    mapController.complete(controller);
    _loadImages(controller);
  }

  void onStyleLoaded() {
    canInteractWithMap = true;
    ref.read(mapStateProvider.notifier).setMapReady(true);
  }

  static Future<String> initStyle() async {
    try {
      // Usar estilo online de MapTiler (recomendado)
      String primaryStyle = "https://api.maptiler.com/maps/streets-v2/style.json?key=MzhKbzEOi3IDm2v3qyrm";
      print("🗺️ Cargando estilo del mapa: $primaryStyle");
      return primaryStyle;
    } catch (e) {
      print("❌ Error initializing style: $e");
      // Fallback a un estilo básico de MapLibre si falla
      String fallbackStyle = "https://demotiles.maplibre.org/style.json";
      print("🔄 Usando estilo de fallback: $fallbackStyle");
      return fallbackStyle;
    }
  }

  // ========== IMAGES ==========
  
  Future<void> _loadImages(MapLibreMapController controller) async {
    await _loadClientImage(controller);
  }

  Future<void> _loadClientImage(MapLibreMapController controller) async {
    try {
      print('🖼️ Cargando imagen específica del cliente: locations.png');
      
      final ByteData bytes = await rootBundle.load("assets/images/locations.png");
      final Uint8List list = bytes.buffer.asUint8List();
      
      await controller.addImage("locations-icon", list);
      print('✅ Imagen locations.png cargada como locations-icon');
    } catch (e) {
      print('⚠️ Error cargando imagen locations.png: $e');
      print('🔄 Cliente usará fallback emoji');
    }
  }

  // ========== ROUTE HANDLING ==========
  
  Future<void> drawRouteOnMap(List<LatLng> routePoints) async {
    if (!mapController.isCompleted) {
      print('⚠️ Mapa no está listo para dibujar ruta');
      return;
    }

    try {
      final controller = await mapController.future;
      
      // Remover ruta anterior si existe
      if (_routeLine != null) {
        await controller.removeLine(_routeLine!);
      }
      
      // Crear nueva línea de ruta
      _routeLine = await controller.addLine(LineOptions(
        geometry: routePoints,
        lineColor: '#FF6B6B',
        lineWidth: 4.0,
        lineOpacity: 0.8,
      ));
      
      // Enfocar la ruta solo si no se ha enfocado antes
      if (!_hasRouteFocused && routePoints.isNotEmpty) {
        final bounds = _calculateBounds(routePoints);
        await controller.animateCamera(
          CameraUpdate.newLatLngBounds(bounds),
          duration: const Duration(milliseconds: 1000),
        );
        _hasRouteFocused = true;
        print('🎯 Ruta enfocada (primera vez)');
      }
      
      print('✅ Ruta dibujada en el mapa con ${routePoints.length} puntos');
    } catch (e) {
      print('❌ Error dibujando ruta: $e');
    }
  }

  // ========== PARADAS MANAGEMENT (usando círculos reales como en enhanced_marker_service) ==========
  
  Future<void> loadParadasForRuta(String rutaId) async {
    // NUEVO: Verificar si las paradas ya están cargadas para esta ruta
    if (_lastLoadedRutaId == rutaId && _currentParadas.isNotEmpty) {
      print('✅ Paradas ya cargadas para ruta $rutaId, omitiendo recarga');
      return;
    }
    
    // NUEVO: Evitar múltiples llamadas simultáneas
    if (_paradasLoadingInProgress) {
      print('⏳ Carga de paradas ya en progreso, omitiendo');
      return;
    }
    
    if (!mapController.isCompleted) {
      print('⚠️ Mapa no está listo para cargar paradas');
      return;
    }

    try {
      _paradasLoadingInProgress = true;
      print('🚏 Cargando paradas para ruta ID: $rutaId');
      
      // Limpiar paradas anteriores solo si es una ruta diferente
      if (_lastLoadedRutaId != rutaId) {
        await clearParadas();
      }
      
      // MEJORADO: Obtener paradas con soporte offline
      final paradas = await ref.read(paradasModelByRutaProvider(rutaId).future);
      
      print('📊 Respuesta de API - Paradas recibidas: ${paradas.length}');
      for (int i = 0; i < paradas.length; i++) {
        final parada = paradas[i];
        print('🚏 Parada $i: ${parada.nombre} (${parada.latitud}, ${parada.longitud}) - Tiempo: ${parada.tiempo}');
      }
      
      if (paradas.isNotEmpty) {
        _currentParadas = paradas;
        _lastLoadedRutaId = rutaId; // NUEVO: Guardar ID de la ruta cargada
        print('💾 Paradas guardadas en _currentParadas: ${_currentParadas.length}');
        
        print('🗺️ Intentando crear círculos en el mapa...');
        await _createParadaCircles();
        
        // Actualizar provider para la UI
        ref.read(selectedParadasProvider.notifier).state = paradas;
        ref.read(selectedRutaIdProvider.notifier).state = rutaId;
        
        print('✅ ${paradas.length} paradas cargadas exitosamente');
        print('🎯 Providers actualizados - Lista UI debería aparecer ahora');
      } else {
        print('⚠️ No se encontraron paradas para la ruta $rutaId');
        _lastLoadedRutaId = rutaId; // Marcar como cargada aunque esté vacía
      }
      
    } catch (e) {
      print('❌ Error cargando paradas: $e');
      print('📍 Stack trace: ${StackTrace.current}');
    } finally {
      _paradasLoadingInProgress = false;
    }
  }

  Future<void> _createParadaCircles() async {
    if (!mapController.isCompleted || _currentParadas.isEmpty) {
      print('❌ No se pueden crear círculos: mapa=${mapController.isCompleted}, paradas=${_currentParadas.length}');
      return;
    }

    try {
      final controller = await mapController.future;
      print('🗺️ Controller de mapa obtenido exitosamente');
      
      // Crear círculos para cada parada (basado en enhanced_marker_service.dart)
      for (int i = 0; i < _currentParadas.length; i++) {
        final parada = _currentParadas[i];
        final location = LatLng(parada.latitud, parada.longitud);
        
        print('🚏 Creando círculo $i para: ${parada.nombre} en (${parada.latitud}, ${parada.longitud})');
        
        // Crear el fondo del círculo (relleno)
        final circlePoints = _generateCirclePoints(location, 0.0005); // Radio un poco más grande para paradas
        
        final fill = await controller.addFill(FillOptions(
          geometry: [circlePoints],
          fillColor: '#2196F3', // Azul
          fillOpacity: 0.6,
        ));
        _paradaFills.add(fill);
        
        // Crear el borde del círculo
        final circle = await controller.addLine(LineOptions(
          geometry: circlePoints,
          lineColor: '#1976D2', // Azul más oscuro para el borde
          lineWidth: 2.0,
          lineOpacity: 1.0,
        ));
        _paradaCircles.add(circle);
        
        print('✅ Círculo ${i+1} creado exitosamente para: ${parada.nombre}');
      }
      
      print('🎯 RESUMEN CÍRCULOS DE PARADAS:');
      print('   📊 Total fills creados: ${_paradaFills.length}');
      print('   📊 Total círculos creados: ${_paradaCircles.length}');
      print('   📊 Total paradas en memoria: ${_currentParadas.length}');
      print('   ✅ Todos los círculos deberían ser visibles en el mapa ahora');
      
    } catch (e) {
      print('❌ Error creando círculos de paradas: $e');
      print('📍 Stack trace detallado: ${StackTrace.current}');
    }
  }

  // Método para generar puntos de círculo (copiado de enhanced_marker_service.dart)
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

  Future<void> clearParadas() async {
    if (!mapController.isCompleted) return;

    try {
      final controller = await mapController.future;
      
      // Remover todos los fills de paradas
      for (final fill in _paradaFills) {
        try {
          await controller.removeFill(fill);
        } catch (e) {
          print('⚠️ Error removiendo fill: $e');
        }
      }
      
      // Remover todos los círculos de paradas
      for (final circle in _paradaCircles) {
        try {
          await controller.removeLine(circle);
        } catch (e) {
          print('⚠️ Error removiendo círculo: $e');
        }
      }
      
      _paradaFills.clear();
      _paradaCircles.clear();
      _currentParadas.clear();
      _lastLoadedRutaId = null; // NUEVO: Limpiar caché
      
      // Limpiar providers
      ref.read(selectedParadasProvider.notifier).state = [];
      ref.read(selectedRutaIdProvider.notifier).state = null;
      
      print('✅ Círculos de paradas limpiados');
      
    } catch (e) {
      print('❌ Error limpiando círculos de paradas: $e');
    }
  }

  List<ParadaModel> get currentParadas => _currentParadas;

  // ========== CLIENT LOCATION MARKER ==========
  
  Future<void> showClientLocation(Position position) async {
    if (!mapController.isCompleted) {
      print('⚠️ Mapa no está listo para mostrar ubicación');
      return;
    }

    try {
      final controller = await mapController.future;
      final location = LatLng(position.latitude, position.longitude);
      
      print('🎯 Iniciando proceso para mostrar ubicación del cliente: ${position.latitude}, ${position.longitude}');
      
      // CRÍTICO: Cargar imágenes antes de crear marcadores
      await _loadImages(controller);
      
      // Remover marcador anterior si existe (según mejores prácticas de Medium)
      if (_clientLocationMarker != null) {
        await controller.removeSymbol(_clientLocationMarker!);
        _clientLocationMarker = null;
        print('🔄 Marcador anterior del cliente removido');
      }
      
      // Crear nuevo marcador de ubicación del cliente
      _clientLocationMarker = await _createClientLocationMarker(controller, location);
      
      // Centrar la cámara en la ubicación del cliente (solo la primera vez)
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(location, 16.0),
        duration: const Duration(milliseconds: 800),
      );
      
      print('✅ Ubicación del cliente mostrada exitosamente: ${position.latitude}, ${position.longitude}');
      
    } catch (e) {
      print('❌ Error mostrando ubicación del cliente: $e');
      rethrow;
    }
  }

  Future<Symbol> _createClientLocationMarker(MapLibreMapController controller, LatLng location) async {
    print('📍 Iniciando creación de marcador de cliente en: ${location.latitude}, ${location.longitude}');
    
    try {
      // Usar imagen específica del cliente (locations.png)
      print('🖼️ Intentando usar imagen locations.png para marcador de cliente');
      final marker = await controller.addSymbol(SymbolOptions(
        geometry: location,
        iconImage: 'locations-icon',
        iconSize: 4.0, // Tamaño 1:1 con imagen ya redimensionada a 48x48px
        iconAnchor: 'bottom',
        iconOffset: const Offset(0, 0),
      ));
      
      print('✅ Marcador de cliente creado exitosamente con imagen locations.png');
      return marker;
      
    } catch (e) {
      print('⚠️ Error con imagen del cliente: $e');
      print('🔄 Usando marcador de fallback (emoji)');
      
      // Fallback a emoji bien visible si falla la imagen
      final fallbackMarker = await controller.addSymbol(SymbolOptions(
        geometry: location,
        textField: '🏠', // Icono de casa para cliente
        textColor: '#4CAF50', // Verde para distinguir del chofer
        textSize: 36.0,
        textHaloColor: '#FFFFFF',
        textHaloWidth: 4.0,
        textAnchor: 'center',
        textOffset: const Offset(0, 0),
      ));
      
      print('✅ Marcador de fallback creado para cliente');
      return fallbackMarker;
    }
  }

  Future<void> hideClientLocation() async {
    if (!mapController.isCompleted || _clientLocationMarker == null) return;

    try {
      final controller = await mapController.future;
      await controller.removeSymbol(_clientLocationMarker!);
      _clientLocationMarker = null;
      
      print('✅ Marcador de ubicación del cliente removido');
    } catch (e) {
      print('❌ Error removiendo marcador del cliente: $e');
    }
  }

  // ========== ROUTE DRAWING ==========
  
  Future<void> addRouteMarkers(List<LatLng> points, String rutaNombre) async {
    if (points.isEmpty || !mapController.isCompleted) return;

    try {
      final controller = await mapController.future;
      
      // Marcador de inicio
      if (points.isNotEmpty) {
        await controller.addSymbol(SymbolOptions(
          geometry: points.first,
          textField: '🟢 INICIO',
          textSize: 12,
          textColor: '#FFFFFF',
          textHaloColor: '#000000',
          textHaloWidth: 2,
          textOffset: const Offset(0, 2),
        ));
      }
      
      // Marcador de fin
      if (points.length > 1) {
        await controller.addSymbol(SymbolOptions(
          geometry: points.last,
          textField: '🔴 FIN',
          textSize: 12,
          textColor: '#FFFFFF',
          textHaloColor: '#000000',
          textHaloWidth: 2,
          textOffset: const Offset(0, 2),
        ));
      }
      
    } catch (e) {
      print('❌ Error agregando marcadores: $e');
    }
  }

  Future<void> clearRoute() async {
    if (!mapController.isCompleted) return;

    try {
      final controller = await mapController.future;
      
      if (_routeLine != null) {
        await controller.removeLine(_routeLine!);
        _routeLine = null;
        _hasRouteFocused = false; // Resetear flag cuando se limpia la ruta
        print('✅ Ruta eliminada del mapa');
      }
    } catch (e) {
      print('❌ Error al limpiar ruta: $e');
    }
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = minLat < point.latitude ? minLat : point.latitude;
      maxLat = maxLat > point.latitude ? maxLat : point.latitude;
      minLng = minLng < point.longitude ? minLng : point.longitude;
      maxLng = maxLng > point.longitude ? maxLng : point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  // ========== CLEANUP ==========
  
  // ========== MICRO TRACKING ==========
  // DEPRECADO: Este método ahora se maneja directamente en ClientTrackingService
  // Se mantiene por compatibilidad pero se redirige al nuevo sistema
  
  Future<void> updateMicroLocationOnMap(Map<String, dynamic> locationData) async {
    print('⚠️ DEPRECADO: updateMicroLocationOnMap en ClientMapController');
    print('📍 Use ClientTrackingService.updateMicroLocationOnMap en su lugar');
    print('🔄 Datos recibidos: $locationData');
    // Ya no procesamos aquí - todo se maneja en ClientTrackingService
  }

  // ========== CLEANUP ==========
  
  void dispose() {
    _mounted = false;
    _syncTimer?.cancel();
    print('🧹 Iniciando limpieza del ClientMapController');
    
    if (mapController.isCompleted) {
      mapController.future.then((controller) {
        try {
          // Limpiar paradas
          clearParadas();
          controller.dispose();
          print('✅ MapController limpiado');
        } catch (e) {
          print('⚠️ Error limpiando MapController: $e');
        }
      }).catchError((e) {
        print('⚠️ Error obteniendo MapController para limpiar: $e');
      });
    }
    
    print('✅ ClientMapController dispose completado');
  }

  // ========== SISTEMA OFFLINE-FIRST PARA CLIENTES ==========
  
  /// Inicializa el sistema offline-first específico para clientes
  Future<void> _initializeOfflineFirstSystem() async {
    print('🌐 === INICIALIZANDO SISTEMA OFFLINE-FIRST PARA CLIENTE ===');
    
    try {
      // PASO 1: Verificar si hay datos offline disponibles
      await _ensureOfflineDataAvailable();
      
      // PASO 2: Configurar sincronización automática cuando hay conexión
      _setupAutoSync();
      
      // PASO 3: Monitorear cambios de conectividad
      _monitorConnectivityForSync();
      
      print('✅ Sistema offline-first para cliente inicializado');
      
    } catch (e) {
      print('❌ Error inicializando sistema offline-first: $e');
    }
  }

  /// Asegura que hay datos offline disponibles para el cliente
  Future<void> _ensureOfflineDataAvailable() async {
    try {
      final entidadRepo = await ref.read(entidadRepositoryProvider.future);
      final rutaRepo = await ref.read(rutaRepositoryProvider.future);
      
      // Verificar si hay datos locales
      final rutasLocales = await (rutaRepo as RutaRepositoryImpl).getAllRutas();
      
      if (rutasLocales.isEmpty) {
        print('📱 No hay datos offline - inicializando datos de respaldo...');
        
        // Poblar datos de respaldo para que el cliente pueda funcionar offline
        await (entidadRepo as EntidadRepositoryImpl).poblarDatosPrueba();
        await (rutaRepo as RutaRepositoryImpl).poblarRutasPrueba();
        
        _hasInitializedOfflineData = true;
        print('✅ Datos offline inicializados para uso del cliente');
      } else {
        print('💾 Datos offline encontrados: ${rutasLocales.length} rutas');
      }
      
    } catch (e) {
      print('⚠️ Error asegurando datos offline: $e');
    }
  }

  /// Configura sincronización automática cada 30 segundos cuando hay conexión
  void _setupAutoSync() {
    _syncTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      final isOnline = ref.read(isOnlineProvider);
      if (isOnline) {
        await _syncDataFromServer();
      }
    });
  }

  /// Monitorea cambios de conectividad para sincronizar datos
  void _monitorConnectivityForSync() {
    ref.listen(isOnlineProvider, (previous, isOnline) async {
      if (isOnline && (previous == false || previous == null)) {
        // Se recuperó la conexión - sincronizar inmediatamente
        print('🟢 Conexión recuperada - sincronizando datos para cliente...');
        await _syncDataFromServer();
      } else if (!isOnline) {
        print('🔴 Conexión perdida - activando modo offline para cliente');
        print('📱 El cliente seguirá funcionando con datos locales');
      }
    });
  }

  /// Sincroniza datos desde el servidor para uso offline del cliente
  Future<void> _syncDataFromServer() async {
    try {
      print('🔄 Sincronizando datos para uso offline del cliente...');
      
      // Invalidar providers para forzar recarga desde API
      ref.invalidate(entidadProvider);
      ref.invalidate(searchRutasProvider);
      
      // Los repositorios automáticamente guardarán los datos en BD local
      print('✅ Sincronización completada - datos actualizados para uso offline');
      
    } catch (e) {
      print('⚠️ Error en sincronización: $e');
    }
  }

  /// Método público para forzar sincronización manual
  Future<void> forceSyncForClient() async {
    final isOnline = ref.read(isOnlineProvider);
    if (isOnline) {
      await _syncDataFromServer();
    } else {
      print('❌ No hay conexión para sincronizar');
    }
  }

  // ========== ESTADO OFFLINE PARA CLIENTES ==========
  
  /// Obtiene el estado actual del modo offline
  bool get isOfflineMode => !ref.read(isOnlineProvider);
  
  /// Muestra información sobre el estado offline al cliente
  void showOfflineStatus() {
    final isOnline = ref.read(isOnlineProvider);
    if (isOnline) {
      print('🟢 CLIENTE: Online - datos sincronizados con servidor');
    } else {
      print('🔴 CLIENTE: Offline - usando datos locales guardados');
      print('📱 Todas las rutas están disponibles offline');
    }
  }
} 