import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../data/datasource/api/parada_api_datasource.dart';
import '../../data/models/parada_model.dart';
import '../../domain/repositories/providers/parada_repository_provider.dart';
import '../../domain/entities/parada.dart';

// Provider para el datasource de paradas (LEGACY - mantener para compatibilidad)
final paradaApiDataSourceProvider = Provider<ParadaApiDataSource>((ref) {
  return ParadaApiDataSourceImpl();
});

// NUEVO: Provider mejorado con soporte offline usando repositorio
final paradasByRutaProvider = FutureProvider.family<List<Parada>, String>((ref, rutaId) async {
  print('🚏 paradasByRutaProvider: Iniciando obtención de paradas para ruta $rutaId');
  
  try {
    final repository = await ref.watch(paradaRepositoryProvider.future);
    print('🚏 paradasByRutaProvider: Repositorio obtenido correctamente');
    
    // Mantener la referencia activa durante 5 minutos para evitar recargas innecesarias
    ref.keepAlive();
    
    // Auto-dispose después de 5 minutos de inactividad
    Timer(const Duration(minutes: 5), () {
      ref.invalidateSelf();
    });
    
    final paradas = await repository.getParadasByRutaId(rutaId);
    print('🚏 paradasByRutaProvider: Repositorio devolvió ${paradas.length} paradas');
    
    return paradas;
  } catch (e) {
    print('❌ Error en paradasByRutaProvider: $e');
    print('📍 Stack trace: ${StackTrace.current}');
    
    // NO CREAR DATOS FALSOS - Permitir que el error se propague para debug
    rethrow;
  }
});

// LEGACY: Provider para compatibilidad con código existiente que espera ParadaModel
final paradasModelByRutaProvider = FutureProvider.family<List<ParadaModel>, String>((ref, rutaId) async {
  try {
    print('🚏 paradasModelByRutaProvider: Obteniendo paradas para ruta $rutaId');
    final paradas = await ref.watch(paradasByRutaProvider(rutaId).future);
    
    print('🚏 paradasModelByRutaProvider: Recibidas ${paradas.length} paradas del repositorio');
    
    // Convertir entidades a modelos para compatibilidad
    final modelos = paradas.map((parada) => ParadaModel()
      ..paradaId = parada.id
      ..idRuta = parada.idRuta
      ..nombre = parada.nombre
      ..latitud = parada.latitud
      ..longitud = parada.longitud
      ..tiempo = parada.tiempo
    ).toList();
    
    print('🚏 paradasModelByRutaProvider: Convertidas ${modelos.length} entidades a modelos');
    return modelos;
  } catch (e) {
    print('❌ Error en paradasModelByRutaProvider: $e');
    print('📍 Stack trace: ${StackTrace.current}');
    
    // NO CREAR DATOS FALSOS - Devolver lista vacía para que funcione la UI
    return [];
  }
});

// Provider para mantener las paradas actualmente seleccionadas
final selectedParadasProvider = StateProvider<List<ParadaModel>>((ref) => []);

// Provider para el ID de la ruta seleccionada
final selectedRutaIdProvider = StateProvider<String?>((ref) => null);

// NUEVO: Provider para caché de paradas con tiempo de vida
final paradaCacheProvider = StateProvider<Map<String, CachedParadas>>((ref) => {});

// Clase para mantener paradas cacheadas con timestamp
class CachedParadas {
  final List<ParadaModel> paradas;
  final DateTime timestamp;
  
  CachedParadas(this.paradas, this.timestamp);
  
  bool get isExpired {
    final now = DateTime.now();
    const cacheLifetime = Duration(minutes: 5);
    return now.difference(timestamp) > cacheLifetime;
  }
} 