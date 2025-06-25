import '../../../domain/repositories/pasaje_repository.dart';
import '../datasource/api/pasaje_remote_datasource.dart';


class PasajeRepositoryImpl implements PasajeRepository {
  final PasajeRemoteDatasource remoteDatasource;
  PasajeRepositoryImpl({required this.remoteDatasource});

  @override
  Future<double> getPrecioPasaje(String idEntidad) {
    return remoteDatasource.getPrecioPasaje(idEntidad);
  }

  @override
  Future<Map<String, dynamic>> pagarPasajeConTarjeta({
    required String idTarjeta,
    required double monto,
    required String idMicro,
  }) {
    return remoteDatasource.pagarConTarjeta( idTarjeta: idTarjeta,monto: monto, idMicro: idMicro);
  }
}
