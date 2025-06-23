import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geolocator/geolocator.dart';

import '../../../common/widgets/app_drawer.dart';
import '../../../domain/entities/ruta.dart';
import '../../providers/ruta_provider.dart';
import '../services/client_map_controller.dart';
import '../services/client_route_manager.dart';
import '../services/location_service.dart';
import '../widgets/client_search_bar.dart';
import '../widgets/client_debug_buttons.dart';
import '../widgets/client_route_info.dart';
import '../widgets/client_map_widget.dart';

class ClientMapPage extends StatelessWidget {
  const ClientMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClientMap();
  }
}

class ClientMap extends ConsumerStatefulWidget {
  const ClientMap({super.key});

  @override
  ConsumerState<ClientMap> createState() => _ClientMapState();
}

class _ClientMapState extends ConsumerState<ClientMap> {
  // ========== CONTROLADORES Y SERVICIOS ==========
  late ClientMapController _mapController;
  late ClientRouteManager _routeManager;
  LocationService? _locationService;
  bool _isViewingMyLocation = false;

  @override
  void initState() {
    super.initState();
    _mapController = ClientMapController(ref);
    _routeManager = ClientRouteManager(ref, _mapController);
    _locationService = LocationService(ref);
    print('🗺️ Mapa cliente inicializado - Socket NO iniciado aún');
  }

  @override
  void dispose() {
    print('🧹 Iniciando limpieza del ClientMapPage');
    
    _routeManager.dispose();
    _mapController.dispose();
    _locationService?.dispose();
    
    super.dispose();
    print('✅ ClientMapPage dispose completado');
  }

  // ========== FUNCIONES DE UBICACIÓN ==========
  
  Future<void> _showMyLocation() async {
    if (_locationService == null) return;
    
    try {
      print('📍 Cliente solicitando ver su ubicación...');
      
      // Verificar permisos
      if (!await _locationService!.checkLocationPermissions()) {
        _showError('Permisos de ubicación denegados');
        return;
      }
      
      // Obtener ubicación actual
      final position = await _locationService!.getCurrentPosition();
      if (position == null) {
        _showError('No se pudo obtener la ubicación actual');
        return;
      }
      
      // Usar el método mejorado del controlador del mapa
      await _mapController.showClientLocation(position);
      
      setState(() {
        _isViewingMyLocation = true;
      });
      
      _showSuccess('Mi ubicación mostrada');
      print('✅ Ubicación del cliente mostrada: ${position.latitude}, ${position.longitude}');
      
    } catch (e) {
      print('❌ Error mostrando ubicación del cliente: $e');
      _showError('Error al obtener ubicación: ${e.toString()}');
    }
  }

  Future<void> _hideMyLocation() async {
    // Usar el método mejorado del controlador del mapa
    await _mapController.hideClientLocation();
    
    setState(() {
      _isViewingMyLocation = false;
    });
    
    _showSuccess('Ubicación ocultada');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ========== BUILD ==========
  
  @override
  Widget build(BuildContext context) {
    // MEJORADO: Escuchar solo la ruta seleccionada específica en lugar de todas las rutas
    ref.listen<Ruta?>(selectedRutaProvider, (previous, selectedRuta) {
      if (selectedRuta != null && selectedRuta != previous) {
        print('🛣️ Nueva ruta seleccionada: ${selectedRuta.nombre}');
        // Crear un AsyncValue simulado para compatibilidad con el método existente
        final rutasList = [selectedRuta];
        final rutasAsync = AsyncData(rutasList);
        _routeManager.handleRouteChange(rutasAsync, context);
      }
    });

    // El tracking se inicia automáticamente en ClientRouteManager

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Cliente'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // Botón para mostrar/ocultar mi ubicación
          IconButton(
            icon: Icon(_isViewingMyLocation ? Icons.location_off : Icons.my_location),
            onPressed: _isViewingMyLocation ? _hideMyLocation : _showMyLocation,
            tooltip: _isViewingMyLocation ? 'Ocultar Mi Ubicación' : 'Ver Mi Ubicación',
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          // Mapa principal
          ClientMapWidget(
            mapController: _mapController,
            onSearchTap: () => _routeManager.onSearchTap(context),
            onRouteCleared: _routeManager.onRouteCleared,
          ),
          
          // Barra de búsqueda
          ClientSearchBar(onSearchTap: () => _routeManager.onSearchTap(context)),
          
          // Botones de debug
          ClientDebugButtons(onRouteCleared: _routeManager.onRouteCleared),
          
          // Información de ruta
          const ClientRouteInfo(),
          
          // Botón flotante para ubicación (siempre visible)
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              onPressed: _isViewingMyLocation ? _hideMyLocation : _showMyLocation,
              backgroundColor: _isViewingMyLocation ? Colors.grey[600] : Colors.blue,
              foregroundColor: Colors.white,
              tooltip: _isViewingMyLocation ? 'Ocultar Mi Ubicación' : 'Ver Mi Ubicación',
              child: Icon(_isViewingMyLocation ? Icons.location_off : Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
} 