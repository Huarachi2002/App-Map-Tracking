class Parada {
  final String id;
  final String idRuta;
  final String nombre;
  final double latitud;
  final double longitud;
  final String tiempo;

  const Parada({
    required this.id,
    required this.idRuta,
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.tiempo,
  });

  @override
  String toString() {
    return 'Parada{id: $id, nombre: $nombre, idRuta: $idRuta, tiempo: $tiempo}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Parada &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
} 