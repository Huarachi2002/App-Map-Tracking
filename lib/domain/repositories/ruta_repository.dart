import 'package:app_map_tracking/domain/entities/ruta.dart';

abstract class RutaRepository{
  Future<Ruta> getRutaByIdEntidad(String id);
  
  // 🔍 Método para obtener todas las rutas (para búsqueda)
  Future<List<Ruta>> getAllRutas();
}