class Criptomoneda {
  final String id;
  final String nombre;
  final String simbolo;
  final bool estado;
  final DateTime createdAt;
  final DateTime updatedAt;

  Criptomoneda({
    required this.id,
    required this.nombre,
    required this.simbolo,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
  });
}
