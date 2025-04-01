class Tarjeta {
  final String id;
  final String idUsuario;
  final String tipoTarjeta;
  final String? nfcId;
  final double saldoActual;
  final bool estado;
  final DateTime fechaRegistro;

  Tarjeta({
    required this.id,
    required this.idUsuario,
    required this.tipoTarjeta,
    this.nfcId,
    required this.saldoActual,
    required this.estado,
    required this.fechaRegistro,
  });

  factory Tarjeta.fromJson(Map<String, dynamic> json) {
    return Tarjeta(
      id: json['id'] as String,
      idUsuario: json['idUsuario'] as String,
      tipoTarjeta: json['tipoTarjeta'] as String,
      nfcId: json['nfcId'] as String?,
      saldoActual: (json['saldoActual'] as num).toDouble(),
      estado: json['estado'] as bool,
      fechaRegistro: DateTime.parse(json['fechaRegistro'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idUsuario': idUsuario,
      'tipoTarjeta': tipoTarjeta,
      'nfcId': nfcId,
      'saldoActual': saldoActual,
      'estado': estado,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }

  Map<String, dynamic> toNfcFormat() {
    return {
      'id_tarjeta': id,
      'saldo_actual': saldoActual,
      'nfc_id': nfcId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }
}
