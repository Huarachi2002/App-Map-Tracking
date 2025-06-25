import 'package:isar/isar.dart';
import '../../models/tarjeta_model.dart';

class TarjetaLocalDatasource {
  final Isar isar;
  TarjetaLocalDatasource(this.isar);

  Future<void> saveTarjeta(TarjetaModel tarjeta) async {
    await isar.writeTxn(() async {
      final existente = await isar.tarjetaModels
          .filter()
          .codigoEqualTo(tarjeta.codigo)
          .findFirst();

      if (existente != null) {
        existente
          ..idCliente = tarjeta.idCliente
          ..tipoTarjeta = tarjeta.tipoTarjeta
          ..nfcId = tarjeta.nfcId
          ..saldoActual = tarjeta.saldoActual
          ..estado = tarjeta.estado
          ..createdAt = tarjeta.createdAt
          ..updatedAt = tarjeta.updatedAt;

        await isar.tarjetaModels.put(existente);
      } else {
        await isar.tarjetaModels.put(tarjeta);
      }
    });
  }

  Future<TarjetaModel?> getTarjetaByCodigo(String codigo) async {
    return await isar.tarjetaModels.filter().codigoEqualTo(codigo).findFirst();
  }

  Future<void> updateTarjeta(TarjetaModel tarjeta) async {
    await saveTarjeta(tarjeta);
  }

  Future<List<TarjetaModel>> getAllTarjetas() async {
    return await isar.tarjetaModels.where().findAll();
  }
}
