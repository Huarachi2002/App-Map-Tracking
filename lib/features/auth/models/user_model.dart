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
  });  factory Usuario.fromJson(Map<String, dynamic> json, String token) {
    try {
      print("JSON recibido en fromJson: $json");
      
      // Verifica si 'user' existe, si no trata de usar el json directamente
      final userJson = json.containsKey('user') ? json['user'] : json;
      
      print("Procesando usuario: $userJson");
      
      // Validar que tengamos la información mínima necesaria
      if (userJson == null || !(userJson is Map<String, dynamic>)) {
        throw Exception('Formato de usuario inválido');
      }
      
      // Datos de cliente y empleado
      Cliente? clienteObj;
      if (json.containsKey('cliente') && json['cliente'] != null) {
        try {
          clienteObj = Cliente.fromJson(json['cliente']);
        } catch (e) {
          print("Error al crear objeto Cliente: $e");
        }
      }
      
      Empleado? empleadoObj;
      if (json.containsKey('empleado') && json['empleado'] != null) {
        try {
          empleadoObj = Empleado.fromJson(json['empleado']);
        } catch (e) {
          print("Error al crear objeto Empleado: $e");
        }
      }
      
      return Usuario(
        id: userJson['id']?.toString() ?? '',
        nombre: userJson['nombre']?.toString() ?? '',
        correo: userJson['correo']?.toString() ?? '',
        tipo: userJson['tipo']?.toString() ?? 'CLIENTE',
        cliente: clienteObj,
        empleado: empleadoObj,
        token: token,
      );
    } catch (e) {
      print("Error al crear Usuario: $e");
      rethrow;
    }
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
    print("Empleado JSON: $json");
    String idMicro = '';
    
    // Manejo seguro de la lista de micros
    if (json.containsKey('micros') && 
        json['micros'] != null && 
        json['micros'] is List && 
        json['micros'].isNotEmpty &&
        json['micros'][0] is Map) {
      idMicro = json['micros'][0]['id']?.toString() ?? '';
    } else {
      print("No se encontró información de micros o formato incorrecto");
    }
    
    return Empleado(
      id: json['id']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? '',
      id_entidad: json['id_entidad']?.toString() ?? '',
      id_micro: idMicro,
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
