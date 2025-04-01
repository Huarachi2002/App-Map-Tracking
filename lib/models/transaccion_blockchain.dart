class TransaccionBlockchain {
  final String id;
  final String? idMovimiento;
  final String? idRetiroEntidad;
  final String tipoTransaccion;
  final String txHash;
  final DateTime fechaRegistro;

  TransaccionBlockchain({
    required this.id,
    this.idMovimiento,
    this.idRetiroEntidad,
    required this.tipoTransaccion,
    required this.txHash,
    required this.fechaRegistro,
  });

  factory TransaccionBlockchain.fromJson(Map<String, dynamic> json) {
    return TransaccionBlockchain(
      id: json['id'] as String,
      idMovimiento: json['idMovimiento'] as String?,
      idRetiroEntidad: json['idRetiroEntidad'] as String?,
      tipoTransaccion: json['tipoTransaccion'] as String,
      txHash: json['txHash'] as String,
      fechaRegistro: DateTime.parse(json['fechaRegistro'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idMovimiento': idMovimiento,
      'idRetiroEntidad': idRetiroEntidad,
      'tipoTransaccion': tipoTransaccion,
      'txHash': txHash,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }
}
