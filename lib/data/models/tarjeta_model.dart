import 'package:isar/isar.dart';
import '../../../domain/entities/tarjeta.dart';

part 'tarjeta_model.g.dart';

@collection
class TarjetaModel {
  TarjetaModel();
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String codigo; // id del backend

  late String idCliente;
  late String tipoTarjeta;
  late String nfcId;
  late double saldoActual;
  late bool estado;
  late DateTime createdAt;
  late DateTime updatedAt;
  late List<String> movimientos; // Puedes ajustar el tipo según tu modelo

  Tarjeta toEntity() => Tarjeta(
    id: codigo,
    idCliente: idCliente,
    tipoTarjeta: tipoTarjeta,
    nfcId: nfcId,
    saldoActual: saldoActual,
    estado: estado,
    createdAt: createdAt,
    updatedAt: updatedAt,
    movimientos: movimientos,
  );

  factory TarjetaModel.fromJson(Map<String, dynamic> json) {
    return TarjetaModel()
      ..codigo = json['id']
      ..idCliente = json['id_cliente']
      ..tipoTarjeta = json['tipo_tarjeta']
      ..nfcId = json['nfc_id']
      ..saldoActual = (json['saldo_actual'] as num).toDouble()
      ..estado = json['estado']
      ..createdAt = DateTime.parse(json['createdAt'])
      ..updatedAt = DateTime.parse(json['updatedAt'])
      ..movimientos = (json['movimientos'] as List?)?.map((e) => e.toString()).toList() ?? [];
  }

  Map<String, dynamic> toJson() => {
    'id': codigo,
    'id_cliente': idCliente,
    'tipo_tarjeta': tipoTarjeta,
    'nfc_id': nfcId,
    'saldo_actual': saldoActual,
    'estado': estado,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'movimientos': movimientos,
  };
}
