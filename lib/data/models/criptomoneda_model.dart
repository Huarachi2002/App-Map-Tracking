class CriptomonedaModel {
  final String id;
  final String nombre;
  final String simbolo;
  final bool estado;
  final DateTime createdAt;
  final DateTime updatedAt;

  CriptomonedaModel({
    required this.id,
    required this.nombre,
    required this.simbolo,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CriptomonedaModel.fromJson(Map<String, dynamic> json) => CriptomonedaModel(
    id: json['id'],
    nombre: json['nombre'],
    simbolo: json['simbolo'],
    estado: json['estado'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}
