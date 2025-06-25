import '../../data/models/tarjeta_model.dart';

abstract class TarjetaRepository {
  Future<TarjetaModel> getTarjetaByCliente(String idCliente);
  Future<void> saveTarjetaLocal(TarjetaModel tarjeta);
  Future<TarjetaModel?> getTarjetaLocalByCodigo(String codigo);
}
