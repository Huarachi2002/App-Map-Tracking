// import '../../datasource/api/tarjeta_api_datasource.dart';
// import '../../datasource/local/tarjeta_local_datasource.dart';
// import '../../models/tarjeta_model.dart';
import '../../../domain/repositories/tarjeta_repository.dart';
import '../datasource/api/tarjeta_api_datasource.dart';
import '../datasource/local/tarjeta_local_datasource.dart';
import '../models/tarjeta_model.dart';

class TarjetaRepositoryImpl implements TarjetaRepository {
  final TarjetaApiDatasource apiDatasource;
  final TarjetaLocalDatasource localDatasource;

  TarjetaRepositoryImpl({required this.apiDatasource, required this.localDatasource});

  @override
  Future<TarjetaModel> getTarjetaByCliente(String idCliente) async {
    final tarjeta = await apiDatasource.getTarjetaByCliente(idCliente);
    // await localDatasource.saveTarjeta(tarjeta);
    return tarjeta;
  }

  @override
  Future<void> saveTarjetaLocal(TarjetaModel tarjeta) async {
    await localDatasource.saveTarjeta(tarjeta);
  }

  @override
  Future<TarjetaModel?> getTarjetaLocalByCodigo(String codigo) async {
    return await localDatasource.getTarjetaByCodigo(codigo);
  }
}
