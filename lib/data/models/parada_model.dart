import 'package:isar/isar.dart';

part 'parada_model.g.dart';

@Collection()
class ParadaModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String paradaId;
  
  late String idRuta;
  late String nombre;
  late double latitud;
  late double longitud;
  late String tiempo;
  
  @ignore
  DateTime get createdAt => DateTime.now();

  ParadaModel();

  ParadaModel.fromJson(Map<String, dynamic> json) {
    paradaId = json['id']?.toString() ?? '';
    idRuta = json['id_ruta']?.toString() ?? '';
    nombre = json['nombre']?.toString() ?? '';
    latitud = double.tryParse(json['latitud'].toString()) ?? 0.0;
    longitud = double.tryParse(json['longitud'].toString()) ?? 0.0;
    tiempo = json['tiempo']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': paradaId,
      'id_ruta': idRuta,
      'nombre': nombre,
      'latitud': latitud,
      'longitud': longitud,
      'tiempo': tiempo,
    };
  }

  @override
  String toString() {
    return 'ParadaModel{id: $paradaId, nombre: $nombre, latitud: $latitud, longitud: $longitud, tiempo: $tiempo}';
  }
} 