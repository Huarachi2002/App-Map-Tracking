class Usuario {
  final String id;
  final String nombre;
  final String correo;
  final String constrasena;
  final String estado;
  final DateTime fechaRegistro;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.constrasena,
    required this.estado,
    required this.fechaRegistro,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      correo: json['correo'] as String,
      constrasena: json['contrasena'] as String,
      estado: json['estado'] as String,
      fechaRegistro: DateTime.parse(json['fechaRegistro'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'contrasena': constrasena,
      'estado': estado,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }
}
