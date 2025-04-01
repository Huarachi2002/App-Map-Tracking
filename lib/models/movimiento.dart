class Movimiento {
  final String id;
  final String idTarjeta;
  final double montoCripto;
  final double montoConvertido;
  final double tasaConversion;
  final DateTime fechaRegistro;

  Movimiento({
    required this.id,
    required this.idTarjeta,
    required this.montoCripto,
    required this.montoConvertido,
    required this.tasaConversion,
    required this.fechaRegistro,
  });

  factory Movimiento.fromJson(Map<String, dynamic> json) {
    return Movimiento(
      id: json['id'] as String,
      idTarjeta: json['idTarjeta'] as String,
      montoCripto: (json['montoCripto'] as num).toDouble(),
      montoConvertido: (json['montoConvertido'] as num).toDouble(),
      tasaConversion: (json['tasaConversion'] as num).toDouble(),
      fechaRegistro: DateTime.parse(json['fechaRegistro'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idTarjeta': idTarjeta,
      'montoCripto': montoCripto,
      'montoConvertido': montoConvertido,
      'tasaConversion': tasaConversion,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }
}
