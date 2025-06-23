import 'package:connectivity_plus/connectivity_plus.dart';

import '../datasource/api/parada_api_datasource.dart';
import '../datasource/local/parada_local_datasource.dart';
import '../../domain/entities/parada.dart';
import '../../domain/repositories/parada_repository.dart';
import '../models/parada_model.dart';

class ParadaRepositoryImpl implements ParadaRepository {
  final ParadaApiDataSource api;
  final ParadaLocalDatasource local;

  ParadaRepositoryImpl(this.api, this.local);

  @override
  Future<List<Parada>> getParadasByRutaId(String rutaId) async {
    print("🚏 === OBTENIENDO PARADAS CON SOPORTE OFFLINE ===");
    print("🛣️ Ruta solicitada: $rutaId");
    
    try {
      // PASO 1: Verificar conectividad
      final hasConnection = await _hasInternetConnection();
      
      if (hasConnection) {
        // PASO 2: Intentar obtener desde API si hay conexión
        try {
          print("🌐 Intentando obtener paradas desde API...");
          final apiData = await api.getParadasByRutaId(rutaId);
          
          print("📊 API devolvió: ${apiData.length} paradas");
          
          if (apiData.isNotEmpty) {
            print("✅ API: Recibidas ${apiData.length} paradas desde backend");
            
            // PASO 3: Guardar en BD local para uso offline
            await local.saveParadasForRuta(rutaId, apiData);
            print("💾 Paradas guardadas en BD local para uso offline");
            
            return apiData.map((model) => _modelToEntity(model)).toList();
          } else {
            print("⚠️ API devolvió 0 paradas para la ruta $rutaId");
            print("🔄 Continuando con fallback a datos locales...");
            
            // IMPORTANTE: No poblar datos falsos aquí - solo usar datos locales reales
          }
        } catch (e) {
          print("⚠️ Error obteniendo paradas desde API: $e");
          print("🔄 Intentando con datos locales...");
        }
      } else {
        print("🔴 Sin conexión a internet - usando modo offline");
      }
      
      // PASO 4: Fallback a datos locales
      final localData = await local.getParadasByRutaId(rutaId);
      
      if (localData.isNotEmpty) {
        print("💾 Paradas locales encontradas: ${localData.length}");
        return localData.map((model) => _modelToEntity(model)).toList();
      } else {
        print("⚠️ No hay paradas para la ruta $rutaId en la base de datos local");
        print("❌ Sin datos reales disponibles offline para esta ruta");
        return [];
      }
      
    } catch (e) {
      print("❌ Error al obtener paradas: $e");
      return [];
    }
  }

  // MÉTODO AUXILIAR: Verificar conectividad a internet
  Future<bool> _hasInternetConnection() async {
    try {
      final connectivity = Connectivity();
      final connectivityResult = await connectivity.checkConnectivity();
      final hasConnection = connectivityResult.isNotEmpty && 
                           !connectivityResult.contains(ConnectivityResult.none);
      
      if (hasConnection) {
        print('🟢 Conexión a internet disponible para paradas');
      } else {
        print('🔴 Sin conexión a internet - modo offline activado para paradas');
      }
      
      return hasConnection;
    } catch (e) {
      print('⚠️ Error verificando conectividad para paradas: $e');
      return false; // Asumir sin conexión en caso de error
    }
  }

  // MÉTODO AUXILIAR: Convertir modelo a entidad
  Parada _modelToEntity(ParadaModel model) {
    return Parada(
      id: model.paradaId,
      idRuta: model.idRuta,
      nombre: model.nombre,
      latitud: model.latitud,
      longitud: model.longitud,
      tiempo: model.tiempo,
    );
  }



  // MÉTODO AUXILIAR: Forzar sincronización cuando hay internet
  Future<void> syncWhenOnline(String rutaId) async {
    if (await _hasInternetConnection()) {
      print('🔄 Sincronizando paradas con el servidor para ruta $rutaId...');
      
      try {
        await getParadasByRutaId(rutaId); // Esto actualizará la BD local automáticamente
        print('✅ Sincronización de paradas completada');
      } catch (e) {
        print('❌ Error en sincronización de paradas: $e');
      }
    } else {
      print('⚠️ No hay conexión para sincronizar paradas');
    }
  }

  // MÉTODO AUXILIAR: Limpiar datos locales de paradas
  Future<void> clearLocalData() async {
    try {
      await local.clearAll();
      print('🧹 Datos locales de paradas limpiados');
    } catch (e) {
      print('❌ Error limpiando datos locales de paradas: $e');
    }
  }
} 