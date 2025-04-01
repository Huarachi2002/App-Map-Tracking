class Pago {
  final String id;
  final String idTarjeta;
  final double montoPagado;
  final String modoPago;
  final String estado;
  final double latitud;
  final double longitud;
  final String idMicro;
  final DateTime fechaRegistro;

  Pago({
    required this.id,
    required this.idTarjeta,
    required this.montoPagado,
    required this.modoPago,
    required this.estado,
    required this.latitud,
    required this.longitud,
    required this.idMicro,
    required this.fechaRegistro,
  });

  factory Pago.fromJson(Map<String, dynamic> json) {
    return Pago(
      id: json['id'] as String,
      idTarjeta: json['idTarjeta'] as String,
      montoPagado: (json['montoPagado'] as num).toDouble(),
      modoPago: json['modoPago'] as String,
      estado: json['estado'] as String,
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      idMicro: json['idMicro'] as String,
      fechaRegistro: DateTime.parse(json['fechaRegistro'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idTarjeta': idTarjeta,
      'montoPagado': montoPagado,
      'modoPago': modoPago,
      'estado': estado,
      'latitud': latitud,
      'longitud': longitud,
      'idMicro': idMicro,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }

  Map<String, dynamic> toNfcFormat() {
    return {
      'id_pago': id,
      'id_tarjeta': idTarjeta,
      'monto': montoPagado,
      'micro': idMicro,
      'timestamp': fechaRegistro.millisecondsSinceEpoch,
    };
  }
}
