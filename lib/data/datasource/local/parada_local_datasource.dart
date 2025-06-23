import 'package:isar/isar.dart';
import '../../models/parada_model.dart';

class ParadaLocalDatasource {
  final Isar isar;

  ParadaLocalDatasource(this.isar);

  /// Guardar múltiples paradas
  Future<void> saveAll(List<ParadaModel> paradas) async {
    await isar.writeTxn(() async {
      for (final nuevaParada in paradas) {
        // Verificar si ya existe una parada con el mismo ID
        final existente = await isar.paradaModels
            .filter()
            .paradaIdEqualTo(nuevaParada.paradaId)
            .findFirst();

        if (existente != null) {
          // Actualizar parada existente
          existente
            ..idRuta = nuevaParada.idRuta
            ..nombre = nuevaParada.nombre
            ..latitud = nuevaParada.latitud
            ..longitud = nuevaParada.longitud
            ..tiempo = nuevaParada.tiempo;

          await isar.paradaModels.put(existente);
        } else {
          // Insertar nueva parada
          await isar.paradaModels.put(nuevaParada);
        }
      }
    });
    print('💾 ${paradas.length} paradas guardadas en BD local');
  }

  /// Guardar paradas específicas para una ruta
  Future<void> saveParadasForRuta(String rutaId, List<ParadaModel> paradas) async {
    await isar.writeTxn(() async {
      // Primero eliminar paradas existentes de esta ruta
      final existingParadas = await isar.paradaModels
          .filter()
          .idRutaEqualTo(rutaId)
          .findAll();
      
      for (final parada in existingParadas) {
        await isar.paradaModels.delete(parada.id);
      }
      
      // Luego insertar las nuevas paradas
      for (final parada in paradas) {
        await isar.paradaModels.put(parada);
      }
    });
    print('💾 ${paradas.length} paradas guardadas para ruta $rutaId');
  }

  /// Obtener todas las paradas
  Future<List<ParadaModel>> getAll() async {
    return await isar.paradaModels.where().findAll();
  }

  /// Obtener paradas por ID de ruta
  Future<List<ParadaModel>> getParadasByRutaId(String rutaId) async {
    print('🔍 Buscando paradas locales para ruta: $rutaId');
    try {
      final paradas = await isar.paradaModels
          .filter()
          .idRutaEqualTo(rutaId)
          .findAll();
      
      print('💾 Paradas locales encontradas para $rutaId: ${paradas.length}');
      return paradas;
    } catch (e) {
      print('❌ Error al buscar paradas locales por ruta: $e');
      rethrow;
    }
  }

  /// Obtener parada por ID
  Future<ParadaModel?> getById(String paradaId) async {
    return await isar.paradaModels
        .filter()
        .paradaIdEqualTo(paradaId)
        .findFirst();
  }

  /// Eliminar parada por ID
  Future<void> deleteById(String paradaId) async {
    await isar.writeTxn(() async {
      final parada = await isar.paradaModels
          .filter()
          .paradaIdEqualTo(paradaId)
          .findFirst();
      if (parada != null) {
        await isar.paradaModels.delete(parada.id);
      }
    });
  }

  /// Eliminar todas las paradas de una ruta
  Future<void> deleteByRutaId(String rutaId) async {
    await isar.writeTxn(() async {
      final paradas = await isar.paradaModels
          .filter()
          .idRutaEqualTo(rutaId)
          .findAll();
      
      for (final parada in paradas) {
        await isar.paradaModels.delete(parada.id);
      }
    });
    print('🗑️ Paradas eliminadas para ruta: $rutaId');
  }

  /// Limpiar todas las paradas
  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.paradaModels.clear();
    });
    print('🧹 Todas las paradas locales eliminadas');
  }

  /// Debug: Imprimir todas las paradas
  Future<void> debugPrintAll() async {
    print('🔍 === DEBUG PARADAS LOCALES ===');
    try {
      final paradas = await getAll();
      
      if (paradas.isEmpty) {
        print('⚠️ No hay paradas almacenadas localmente');
        return;
      }

      print('📊 Total de paradas locales: ${paradas.length}');
      
      // Agrupar por ruta
      final Map<String, List<ParadaModel>> paradasPorRuta = {};
      for (final parada in paradas) {
        if (!paradasPorRuta.containsKey(parada.idRuta)) {
          paradasPorRuta[parada.idRuta] = [];
        }
        paradasPorRuta[parada.idRuta]!.add(parada);
      }

      for (final entry in paradasPorRuta.entries) {
        final rutaId = entry.key;
        final paradasRuta = entry.value;
        
        print('🛣️ Ruta $rutaId: ${paradasRuta.length} paradas');
        for (int i = 0; i < paradasRuta.length; i++) {
          final parada = paradasRuta[i];
          print('  🚏 ${i + 1}. ${parada.nombre} (${parada.latitud}, ${parada.longitud}) - ${parada.tiempo}');
        }
      }
      
      print('=== FIN DEBUG PARADAS ===');
    } catch (e) {
      print('❌ Error en debug de paradas: $e');
    }
  }

  /// Debug: Imprimir paradas de una ruta específica
  Future<void> debugPrintByRuta(String rutaId) async {
    print('🔍 === DEBUG PARADAS PARA RUTA: $rutaId ===');
    try {
      final paradas = await getParadasByRutaId(rutaId);
      
      if (paradas.isEmpty) {
        print('⚠️ No hay paradas almacenadas para la ruta $rutaId');
        return;
      }

      for (int i = 0; i < paradas.length; i++) {
        final parada = paradas[i];
        print('🚏 --- Parada ${i + 1} ---');
        print('  📍 ID: ${parada.paradaId}');
        print('  🛣️ Ruta: ${parada.idRuta}');
        print('  📛 Nombre: ${parada.nombre}');
        print('  📍 Coordenadas: (${parada.latitud}, ${parada.longitud})');
        print('  ⏰ Tiempo: ${parada.tiempo}');
      }
      print('=== FIN DEBUG PARADAS RUTA ===');
    } catch (e) {
      print('❌ Error en debug de paradas por ruta: $e');
    }
  }
} 