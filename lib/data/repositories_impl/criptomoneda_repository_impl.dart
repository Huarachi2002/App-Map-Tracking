import '../../domain/entities/criptomoneda.dart';
import '../models/criptomoneda_model.dart';
import '../datasource/api/criptomoneda_api_datasource.dart';
import '../../domain/repositories/criptomoneda_repository.dart';

class CriptomonedaRepositoryImpl implements CriptomonedaRepository {
  final CriptomonedaApiDatasource apiDatasource;
  CriptomonedaRepositoryImpl({required this.apiDatasource});

  @override
  Future<List<Criptomoneda>> getCriptomonedas() async {
    final models = await apiDatasource.getCriptomonedas();
    return models.map((e) => Criptomoneda(
      id: e.id,
      nombre: e.nombre,
      simbolo: e.simbolo,
      estado: e.estado,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    )).toList();
  }

  @override
  Future<double> getTipoCambioCripto(String origen, String destino) {
    return apiDatasource.getTipoCambioCripto(origen, destino);
  }
}
