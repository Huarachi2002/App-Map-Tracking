class Usuario {
  final String id;
  final String nombre;
  final String correo;
  final String tipo; // cliente, empleado, admin
  final Cliente? cliente;
  final Empleado? empleado;
  final String token;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.tipo,
    this.cliente,
    this.empleado,
    required this.token,
  });

  factory Usuario.fromJson(Map<String, dynamic> json, String token) {
    return Usuario(
      id: json['user']['id'],
      nombre: json['user']['nombre'],
      correo: json['user']['correo'],
      tipo: json['user']['tipo'] ?? 'CLIENTE',
      cliente:
          json['cliente'] != null ? Cliente.fromJson(json['cliente']) : null,
      empleado:
          json['empleado'] != null ? Empleado.fromJson(json['empleado']) : null,
      token: token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'tipo': tipo,
      'cliente': cliente?.toJson(),
      'empleado': empleado?.toJson()
    };
  }
}

class Cliente {
  final String id;
  final String wallet_address;
  final List<dynamic>? registros;
  final List<dynamic>? notificaciones;
  final List<dynamic>? tarjetas;

  Cliente({
    required this.id,
    required this.wallet_address,
    this.registros,
    this.notificaciones,
    this.tarjetas,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
        id: json['id'] ?? '',
        wallet_address: json['wallet_address'] ?? '',
        registros: json['registros'],
        notificaciones: json['notificaciones'],
        tarjetas: json['tarjetas']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wallet_address': wallet_address,
      'registros': registros,
      'notificaciones': notificaciones,
      'tarjetas': tarjetas,
    };
  }
}

class Empleado {
  final String id;
  final String tipo; // CHOFER, ADMIN
  final String id_entidad;
  final String id_micro;

  Empleado({
    required this.id,
    required this.tipo,
    required this.id_entidad,
    required this.id_micro,
  });

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      id: json['id'] ?? '',
      tipo: json['tipo'] ?? '',
      id_entidad: json['id_entidad'] ?? '',
      id_micro: json['micros'][0]['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'id_entidad': id_entidad,
      'id_micro': id_micro,
    };
  }
}
