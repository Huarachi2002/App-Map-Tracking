import 'package:isar/isar.dart';
import '../../models/ruta_model.dart';

class RutaLocalDatasource {
  final Isar isar;

  RutaLocalDatasource(this.isar);

  Future<void> saveAll(List<RutaModel> rutas) async {
    await isar.writeTxn(() async {
      for (final nuevaRuta in rutas) {
        final existente = await isar.rutaModels
            .filter()
            .codigoEqualTo(nuevaRuta.codigo)
            .findFirst();

        if (existente != null) {
          existente
            ..idEntidad = nuevaRuta.idEntidad
            ..nombre = nuevaRuta.nombre
            ..descripcion = nuevaRuta.descripcion
            ..origenLat = nuevaRuta.origenLat
            ..origenLong = nuevaRuta.origenLong
            ..destinoLat = nuevaRuta.destinoLat
            ..destinoLong = nuevaRuta.destinoLong
            ..vertices = nuevaRuta.vertices
            ..distancia = nuevaRuta.distancia
            ..tiempo = nuevaRuta.tiempo
            ..createdAt = nuevaRuta.createdAt
            ..updatedAt = nuevaRuta.updatedAt;

          await isar.rutaModels.put(existente);
        } else {
          await isar.rutaModels.put(nuevaRuta);
        }
      }
    });
  }

  Future<List<RutaModel>> getAll() async {
    return await isar.rutaModels.where().findAll();
  }

  Future<RutaModel?> getById(String id) async {
    return await isar.rutaModels.filter().codigoEqualTo(id).findFirst();
  }

  Future<void> deleteById(String id) async {
    await isar.writeTxn(() async {
      final ruta = await isar.rutaModels.filter().codigoEqualTo(id).findFirst();
      if (ruta != null) {
        await isar.rutaModels.delete(ruta.id);
      }
    });
  }

  // 🔍 Función de debug para imprimir todos los datos de rutas
  Future<void> debugPrintAll() async {
    final rutas = await getAll();
    print('🛣️ === DATOS LOCALES DE RUTAS ===');
    print('📋 Total de rutas: ${rutas.length}');
    
    for (int i = 0; i < rutas.length; i++) {
      final ruta = rutas[i];
      print('');
      print('🚌 Ruta ${i + 1}:');
      print('   ID: ${ruta.id} (Auto-increment)');
      print('   Código: ${ruta.codigo}');
      print('   ID Entidad: ${ruta.idEntidad}');
      print('   Nombre: ${ruta.nombre}');
      print('   Descripción: ${ruta.descripcion}');
      print('   Origen: (${ruta.origenLat}, ${ruta.origenLong})');
      print('   Destino: (${ruta.destinoLat}, ${ruta.destinoLong})');
      print('   Distancia: ${ruta.distancia} km');
      print('   Tiempo: ${ruta.tiempo} min');
      print('   Vertices: ${ruta.vertices.length > 50 ? ruta.vertices.substring(0, 50) + "..." : ruta.vertices}');
      print('   Creado: ${ruta.createdAt}');
      print('   Actualizado: ${ruta.updatedAt}');
    }
    
    if (rutas.isEmpty) {
      print('⚠️  No hay rutas almacenadas localmente');
    }
    print('🛣️ === FIN DATOS RUTAS ===');
  }

  // 🗑️ Función para limpiar todos los datos (para testing)
  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.rutaModels.clear();
    });
    print('🗑️ Todas las rutas han sido eliminadas de la BD local');
  }

  // 🔍 Obtener rutas por entidad específica
  Future<List<RutaModel>> getRutasByEntidad(String idEntidad) async {
    print("🔍 Buscando rutas para entidad: $idEntidad");
    try {
      final rutas = await isar.rutaModels
          .filter()
          .idEntidadEqualTo(idEntidad)
          .findAll();
      print("💾 Rutas encontradas para $idEntidad: ${rutas.length}");
      return rutas;
    } catch (e) {
      print("❌ Error al buscar rutas por entidad: $e");
      rethrow;
    }
  }

  // 🔍 Debug para rutas de una entidad específica
  Future<void> debugPrintByEntidad(String idEntidad) async {
    print("🔍 === DEBUG RUTAS PARA ENTIDAD: $idEntidad ===");
    try {
      final rutas = await getRutasByEntidad(idEntidad);
      
      if (rutas.isEmpty) {
        print("⚠️  No hay rutas almacenadas para la entidad $idEntidad");
        return;
      }

      for (int i = 0; i < rutas.length; i++) {
        final ruta = rutas[i];
        print("🚌 --- Ruta ${i + 1} ---");
        print("  📍 ID: ${ruta.codigo}");
        print("  🏢 Entidad: ${ruta.idEntidad}");
        print("  📛 Nombre: ${ruta.nombre}");
        print("  📝 Descripción: ${ruta.descripcion}");
        print("  🚩 Origen: (${ruta.origenLat}, ${ruta.origenLong})");
        print("  🏁 Destino: (${ruta.destinoLat}, ${ruta.destinoLong})");
        print("  📏 Distancia: ${ruta.distancia}km");
        print("  ⏱️  Tiempo: ${ruta.tiempo}min");
        print("  🗓️  Creado: ${ruta.createdAt}");
      }
      print("=== FIN DEBUG RUTAS ===");
    } catch (e) {
      print("❌ Error en debug de rutas: $e");
    }
  }
}