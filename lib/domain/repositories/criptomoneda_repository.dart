import '../entities/criptomoneda.dart';

abstract class CriptomonedaRepository {
  Future<List<Criptomoneda>> getCriptomonedas();
  Future<double> getTipoCambioCripto(String origen, String destino);
}
