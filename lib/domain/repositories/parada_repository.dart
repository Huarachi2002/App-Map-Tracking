import '../entities/parada.dart';

abstract class ParadaRepository {
  Future<List<Parada>> getParadasByRutaId(String rutaId);
} 