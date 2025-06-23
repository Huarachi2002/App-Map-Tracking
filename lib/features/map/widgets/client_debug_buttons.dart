import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/shared_preference_helper.dart';
import '../../../data/datasource/local/providers/entidad_local_datasource_provider.dart';
import '../../../data/datasource/local/providers/ruta_local_datasource_provider.dart';
import '../../../data/datasource/local/providers/isar_provider.dart';
import '../../../data/repositories_impl/entidad_repository_impl.dart';
import '../../../data/repositories_impl/ruta_repository_impl.dart';
import '../../../domain/repositories/providers/entidad_repository_provider.dart';
import '../../../domain/repositories/providers/ruta_repository_provider.dart';
import '../../providers/entidad_provider.dart';
import '../../providers/ruta_provider.dart';
import '../../providers/entidad_id_provider.dart';
import '../../providers/parada_provider.dart';
import '../widgets/client_paradas_list.dart';

class ClientDebugButtons extends ConsumerWidget {
  final Function()? onRouteCleared;

  const ClientDebugButtons({
    super.key,
    this.onRouteCleared,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paradas = ref.watch(selectedParadasProvider);
    
    return Stack(
      children: [
        // Botón de debug
        Positioned(
          top: 70,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            heroTag: "debug_btn",
            backgroundColor: Colors.orange,
            onPressed: () => _debugLocalData(context, ref),
            child: const Icon(Icons.bug_report, color: Colors.white),
          ),
        ),
        
        // Botón de inicializar datos offline
        Positioned(
          top: 120,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            heroTag: "init_offline_btn",
            backgroundColor: Colors.blue,
            onPressed: () => _initializeOfflineData(context, ref),
            child: const Icon(Icons.download_for_offline, color: Colors.white),
          ),
        ),
        
        // Botón de limpiar ruta
        Positioned(
          top: 170,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            heroTag: "clear_route_btn",
            backgroundColor: Colors.red,
            onPressed: () => _clearRoute(context, ref),
            child: const Icon(Icons.clear, color: Colors.white),
          ),
        ),
        
        // NUEVO: Botón de mostrar paradas (solo aparece si hay paradas)
        if (paradas.isNotEmpty)
          Positioned(
            top: 220,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              heroTag: "paradas_list_btn",
              backgroundColor: Colors.blue[700],
              onPressed: () => _showParadasModal(context),
              child: Stack(
                children: [
                  const Icon(Icons.bus_alert, color: Colors.white),
                  // Badge con número de paradas
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '${paradas.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        // Botón de actualizar a Santa Cruz
        Positioned(
          top: 270,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            heroTag: "santa_cruz_btn",
            backgroundColor: Colors.green,
            onPressed: () => _updateToSantaCruz(context, ref),
            child: const Icon(Icons.location_city, color: Colors.white),
          ),
        ),
        
        // Botón de ubicación de BD
        Positioned(
          top: 320,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            heroTag: "db_location_btn",
            backgroundColor: Colors.purple,
            onPressed: () => _showDatabaseLocation(context, ref),
            child: const Icon(Icons.folder, color: Colors.white),
          ),
        ),
        
        // Botón de debug de micros
        Positioned(
          top: 370,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            heroTag: "debug_micros_btn",
            backgroundColor: Colors.teal,
            onPressed: () => _debugMicroTracking(context, ref),
            child: const Icon(Icons.directions_bus, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<void> _debugLocalData(BuildContext context, WidgetRef ref) async {
    print('🔍 === INICIANDO DEBUG MODO SOLO LOCAL ===');
    
    try {
      final entidadLocal = await ref.read(entidadLocalDataSourceProvider.future);
      final rutaLocal = await ref.read(rutaLocalDataSourceProvider.future);
      final entidadRepo = await ref.read(entidadRepositoryProvider.future);
      final rutaRepo = await ref.read(rutaRepositoryProvider.future);
      
      print('📱 === VERIFICANDO DATOS LOCALES ===');
      
      if (entidadLocal != null) {
        final entidadesExistentes = await entidadLocal.getAll();
        if (entidadesExistentes.isEmpty) {
          print('🌱 No hay entidades locales, poblando datos de prueba...');
          await (entidadRepo as EntidadRepositoryImpl).poblarDatosPrueba();
        }
        await entidadLocal.debugPrintAll();
      }
      
      if (rutaLocal != null) {
        final rutasExistentes = await rutaLocal.getAll();
        if (rutasExistentes.isEmpty) {
          print('🌱 No hay rutas locales, poblando datos de prueba...');
          await (rutaRepo as RutaRepositoryImpl).poblarRutasPrueba();
        }
        await rutaLocal.debugPrintAll();
      }
      
      print('✅ === DATOS LOCALES LISTOS PARA USO ===');
      
      ref.invalidate(entidadProvider);
      ref.invalidate(searchRutasProvider);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🔍 Datos locales verificados y actualizados. Revisa la consola para detalles.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
      
    } catch (e) {
      print('❌ Error en debug: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _initializeOfflineData(BuildContext context, WidgetRef ref) async {
    print('🌱 === INICIALIZANDO DATOS OFFLINE ===');
    
    try {
      final entidadRepo = await ref.read(entidadRepositoryProvider.future);
      final rutaRepo = await ref.read(rutaRepositoryProvider.future);
      
      print('🏢 Poblando entidades de prueba...');
      await (entidadRepo as EntidadRepositoryImpl).poblarDatosPrueba();
      
      print('🛣️ Poblando rutas de prueba...');
      await (rutaRepo as RutaRepositoryImpl).poblarRutasPrueba();
      
      ref.invalidate(entidadProvider);
      ref.invalidate(searchRutasProvider);
      
      print('✅ Datos offline inicializados correctamente');
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🌱 Datos offline inicializados. ¡Ya puedes buscar líneas!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
      
    } catch (e) {
      print('❌ Error al inicializar datos offline: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al inicializar: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _clearRoute(BuildContext context, WidgetRef ref) async {
    print('🗑️ === LIMPIANDO RUTA ===');
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(SharedPreferenceHelper.SELECTED_ENTIDAD_ID);
      print('🧹 Selección de entidad limpiada');

      ref.invalidate(entidadIdProvider);
      ref.invalidate(searchRutasProvider);

      onRouteCleared?.call();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🗑️ Ruta limpiada del mapa'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
      
    } catch (e) {
      print('❌ Error al limpiar ruta: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al limpiar: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _updateToSantaCruz(BuildContext context, WidgetRef ref) async {
    print('🌟 === ACTUALIZANDO A SANTA CRUZ ===');
    
    try {
      final entidadRepo = await ref.read(entidadRepositoryProvider.future);
      final rutaRepo = await ref.read(rutaRepositoryProvider.future);
      final entidadLocal = await ref.read(entidadLocalDataSourceProvider.future);
      final rutaLocal = await ref.read(rutaLocalDataSourceProvider.future);
      
      if (entidadLocal != null) {
        await entidadLocal.clearAll();
        print('🧹 Datos de entidades limpiados');
      }
      
      if (rutaLocal != null) {
        await rutaLocal.clearAll();
        print('🧹 Datos de rutas limpiados');
      }
      
      print('🏙️ Poblando entidades de Santa Cruz...');
      await (entidadRepo as EntidadRepositoryImpl).poblarDatosPrueba();
      
      print('🛣️ Poblando rutas de Santa Cruz...');
      await (rutaRepo as RutaRepositoryImpl).poblarRutasPrueba();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(SharedPreferenceHelper.SELECTED_ENTIDAD_ID);
      
      ref.invalidate(entidadProvider);
      ref.invalidate(entidadIdProvider);
      ref.invalidate(searchRutasProvider);
      
      print('✅ Actualización a Santa Cruz completada');
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🌟 ¡Actualizado a rutas de Santa Cruz de la Sierra!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
      
    } catch (e) {
      print('❌ Error al actualizar a Santa Cruz: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _showDatabaseLocation(BuildContext context, WidgetRef ref) async {
    print('📂 === UBICACIÓN DE BASE DE DATOS ===');
    
    try {
      final isar = await ref.read(isarProvider.future);
      
      if (isar != null) {
        print('📂 Directorio de Isar: ${isar.directory}');
        print('📂 Nombre de la BD: default.isar');
        print('📂 Ruta completa: ${isar.directory}/default.isar');
        print('📂 Isar está abierto: ${isar.isOpen}');
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📂 Ubicación de la Base de Datos:'),
                  const SizedBox(height: 4),
                  Text(
                    '${isar.directory}/default.isar',
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ],
              ),
              backgroundColor: Colors.purple,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      } else {
        print('❌ Isar no está inicializado');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Isar no está inicializado'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
      
    } catch (e) {
      print('❌ Error al obtener ubicación de BD: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _debugMicroTracking(BuildContext context, WidgetRef ref) async {
    print('🚌 === DEBUG DE TRACKING DE MICROS ===');
    
    try {
      // Esta función necesitará acceso al ClientTrackingService
      // Por ahora, mostrar información básica
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🚌 Debug de micros - Revisa la consola para detalles'),
            backgroundColor: Colors.teal,
            duration: Duration(seconds: 3),
          ),
        );
      }
      
      // TODO: Implementar acceso al ClientTrackingService para:
      // - Mostrar estado de conexión del socket
      // - Mostrar micros en memoria
      // - Forzar actualización de datos
      // - Mostrar antigüedad de los datos
      
      print('🚌 Esta función necesita ser conectada con ClientTrackingService');
      print('🚌 Para implementación completa, se necesita pasar el servicio como parámetro');
      
    } catch (e) {
      print('❌ Error en debug de micros: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // NUEVA función para mostrar las paradas en un modal
  void _showParadasModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: const ClientParadasList(),
      ),
    );
  }
} 