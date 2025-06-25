class Tarjeta {
  final String id;
  final String idCliente;
  final String tipoTarjeta;
  final String nfcId;
  final double saldoActual;
  final bool estado;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> movimientos;

  Tarjeta({
    required this.id,
    required this.idCliente,
    required this.tipoTarjeta,
    required this.nfcId,
    required this.saldoActual,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
    required this.movimientos,
  });
}
