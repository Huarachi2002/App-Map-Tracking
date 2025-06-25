import 'package:app_map_tracking/features/auth/models/user_model.dart';
import 'package:app_map_tracking/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../config/constants.dart';
import '../../../features/providers/micrero_provider.dart';
import '../../../common/shared_preference_helper.dart';
import '../../../services/tracking_socket_service.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

// Provider para almacenar el usuario actual
final userProvider = StateProvider<UserModel?>((ref) => null);

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ApiService(baseUrl: baseUrl), ref);
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;
  final Ref _ref;

  AuthStateNotifier(this._apiService, this._ref) : super(AuthState.initial);
  
  // El usuario ahora lo obtenemos directamente del userProvider
  UserModel? get user => _ref.read(userProvider);  Future<void> login(String email, String password) async {
    state = AuthState.loading;
    
    try {
      print('🔐 Iniciando proceso de login...');
      print('👤 Email: $email');
      
      // NUEVO: Limpiar datos de usuario previos antes de login
      await _clearPreviousUserData();
      
      // PASO 1: Intentar login online primero
      bool loginSuccess = false;
      UserModel? user;
      
      try {
        print('🌐 Intentando login online...');
        final response = await _apiService.post('auth/sign-in', {
          'correo': email,
          'contrasena': password,
        });

        print('📱 Response: $response');

        // Verificar si el login fue exitoso basado en el código de estado o mensaje
        if (response['success'] == true || 
            response['message'] == 'Login exitoso' ||
            response['message'] == 'Logged aceptado' ||
            (response['statusCode'] != null && response['statusCode'] >= 200 && response['statusCode'] < 300)) {
          
          // Para respuestas del servidor con estructura {statusCode, message, data}
          Map<String, dynamic> loginData = response;
          if (response.containsKey('data') && response['data'] != null) {
            loginData = response['data'];
            // Conservar el token del nivel superior si existe
            if (response.containsKey('token')) {
              loginData['token'] = response['token'];
            }
          }
          
          user = UserModel.fromJson(loginData);
          loginSuccess = true;
          print('✅ Login online exitoso');
          
          // AGREGAR: Guardar el token JWT por separado
          try {
            String? authToken;
            if (response.containsKey('token')) {
              authToken = response['token'];
            } else if (response.containsKey('data') && response['data'].containsKey('token')) {
              authToken = response['data']['token'];
            }
            
            if (authToken != null) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('auth_token', authToken);
              print('💾 Token JWT guardado exitosamente');
            } else {
              print('⚠️ No se encontró token en la respuesta del servidor');
            }
          } catch (e) {
            print('⚠️ Error guardando token: $e');
          }
          
          // Guardar credenciales para login offline futuro
          await _saveCredentialsForOffline(email, password, user);
        }
      } catch (e) {
        print('⚠️ Error en login online: $e');
        print('🔄 Intentando login offline...');
        
        // PASO 2: Intentar login offline si el online falla
        user = await _attemptOfflineLogin(email, password);
        if (user != null) {
          loginSuccess = true;
          print('✅ Login offline exitoso');
        }
      }

      if (!loginSuccess || user == null) {
        throw Exception('Credenciales incorrectas');
      }



      // Actualizar estado de autenticación
      _ref.read(userProvider.notifier).state = user;
      await SharedPreferenceHelper.setUserLogged(user);
      
      print('👤 Usuario autenticado: ${user.nombre}');
      print('🏢 Tipo: ${user.tipo}');
      print('🚌 Es micrero: ${user.esMicrero}');
      print('👥 Es cliente: ${user.esCliente}');

      if (user.esMicrero && user.entidadId != null) {
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('entidad_id', user.entidadId!);
          print('💾 Entidad ID guardada en localStorage: ${user.entidadId}');
        } catch (e) {
          print('⚠️ Error guardando entidad ID: $e');
        }
      }else if(user.esCliente){

      }
      
      // NUEVO: Guardar datos del usuario para background service
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', user.id);
        if (user.microId != null) {
          await prefs.setString('user_micro_id', user.microId!);
          print('💾 Micro ID guardado: ${user.microId}');
        }
        if (user.placaMicro != null) {
          await prefs.setString('user_placa_micro', user.placaMicro!);
          print('💾 Placa micro guardada: ${user.placaMicro}');
        }
        print('💾 Datos de usuario guardados para background service');
      } catch (e) {
        print('⚠️ Error guardando datos de usuario: $e');
      }

      state = AuthState.authenticated;
      
    } catch (e) {
      print('❌ Error en login: $e');
      state = AuthState.unauthenticated;
      rethrow;
    }
  }

  // NUEVO: Guardar credenciales para login offline
  Future<void> _saveCredentialsForOffline(String email, String password, UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Guardar hash simple de la contraseña (no la contraseña real por seguridad)
      final passwordHash = password.hashCode.toString();
      
      await prefs.setString('offline_email', email);
      await prefs.setString('offline_password_hash', passwordHash);
      await prefs.setString('offline_user_data', json.encode(user.toJson()));
      await prefs.setBool('has_offline_credentials', true);
      
      print('💾 Credenciales guardadas para login offline');
    } catch (e) {
      print('⚠️ Error guardando credenciales offline: $e');
    }
  }

  // NUEVO: Intentar login offline
  Future<UserModel?> _attemptOfflineLogin(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final hasOfflineCredentials = prefs.getBool('has_offline_credentials') ?? false;
      if (!hasOfflineCredentials) {
        print('❌ No hay credenciales offline guardadas');
        return null;
      }

      final savedEmail = prefs.getString('offline_email');
      final savedPasswordHash = prefs.getString('offline_password_hash');
      final savedUserData = prefs.getString('offline_user_data');

      if (savedEmail == null || savedPasswordHash == null || savedUserData == null) {
        print('❌ Datos offline incompletos');
        return null;
      }

      // Verificar credenciales
      if (savedEmail != email || savedPasswordHash != password.hashCode.toString()) {
        print('❌ Credenciales offline no coinciden');
        return null;
      }

      // Cargar datos del usuario
      final userData = json.decode(savedUserData);
      final user = UserModel.fromJson(userData);
      
      print('✅ Login offline exitoso para: ${user.nombre}');
      return user;
      
    } catch (e) {
      print('❌ Error en login offline: $e');
      return null;
    }
  }

  // NUEVO: Verificar si hay credenciales offline disponibles
  Future<bool> hasOfflineCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('has_offline_credentials') ?? false;
    } catch (e) {
      return false;
    }
  }

  // NUEVO: Obtener token JWT almacenado
  static Future<String> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token') ?? '';
    } catch (e) {
      print('⚠️ Error obteniendo token: $e');
      return '';
    }
  }

  // NUEVO: Limpiar credenciales offline (para logout)
  Future<void> clearOfflineCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('offline_email');
      await prefs.remove('offline_password_hash');
      await prefs.remove('offline_user_data');
      await prefs.setBool('has_offline_credentials', false);
      print('🗑️ Credenciales offline eliminadas');
    } catch (e) {
      print('⚠️ Error eliminando credenciales offline: $e');
    }
  }

  // NUEVO: Limpiar datos de usuario previos antes de nuevo login
  Future<void> _clearPreviousUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Lista de claves de datos de usuario a limpiar
      final userDataKeys = [
        'user_id',
        'user_micro_id', 
        'user_placa_micro',
        'ruta_activa_id',
        'ruta_activa_nombre',
        'entidad_id',
        'user_type',
      ];
      
      for (final key in userDataKeys) {
        await prefs.remove(key);
      }
      
      // Limpiar también el estado del usuario actual
      _ref.read(userProvider.notifier).state = null;
      
      print('🧹 Datos de usuario previos limpiados');
    } catch (e) {
      print('⚠️ Error limpiando datos previos: $e');
    }
  }

  Future<void> logout() async {
    print('🔓 Iniciando proceso de logout...');
    
    // Cambiar el estado inmediatamente para evitar problemas de UI
    state = AuthState.loading;
    
    try {
      // 1. Detener servicios de tracking si están activos
      try {
        final trackingService = TrackingSocketService();
        trackingService.stopLocationTracking();
        trackingService.dispose();
        print('✅ Servicios de tracking detenidos');
      } catch (e) {
        print('⚠️ Error deteniendo tracking: $e');
        // No es crítico si falla
      }
      
      // 2. Limpiar datos de SharedPreferences de forma más robusta
      try {
        final prefs = await SharedPreferences.getInstance();
        
        // Lista de todas las claves a limpiar
        final keysToRemove = [
          SharedPreferenceHelper.USER_LOGGED_KEY,
          SharedPreferenceHelper.SELECTED_ENTIDAD_ID,
          SharedPreferenceHelper.RUTA_ID_KEY,
          'pendingLocations',
          'entidad_id',
          'ruta_activa_id',
          'ruta_activa_nombre',
          'user_type',
          'is_logged_in',
        ];
        
        // Limpiar cada clave
        for (final key in keysToRemove) {
          try {
            await prefs.remove(key);
          } catch (e) {
            print('⚠️ Error limpiando clave $key: $e');
          }
        }
        
        // Limpiar todas las claves que empiecen con ciertos prefijos
        final allKeys = prefs.getKeys();
        for (final key in allKeys) {
          if (key.startsWith('location_') || 
              key.startsWith('route_') || 
              key.startsWith('tracking_')) {
            try {
              await prefs.remove(key);
            } catch (e) {
              print('⚠️ Error limpiando clave prefijo $key: $e');
            }
          }
        }
        
        print('✅ SharedPreferences limpiado completamente');
      } catch (e) {
        print('⚠️ Error limpiando SharedPreferences: $e');
        // Intentar limpiar al menos las claves principales
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear(); // Limpiar todo como último recurso
          print('✅ SharedPreferences limpiado con clear()');
        } catch (clearError) {
          print('❌ Error en clear(): $clearError');
        }
      }
      
      // 3. Limpiar el estado del usuario en el provider de forma segura
      try {
        _ref.read(userProvider.notifier).state = null;
        print('✅ Estado de usuario limpiado');
      } catch (e) {
        print('⚠️ Error limpiando estado de usuario: $e');
      }
      
      // 4. Cambiar el estado de autenticación
      state = AuthState.unauthenticated;
      
      print('✅ Logout completado exitosamente');
      
    } catch (e) {
      print('❌ Error durante logout: $e');
      
      // Aún así, intentar limpiar el estado básico para no dejar la app en estado inconsistente
      try {
        _ref.read(userProvider.notifier).state = null;
        state = AuthState.unauthenticated;
        print('✅ Estado básico limpiado después de error');
      } catch (stateError) {
        print('❌ Error crítico limpiando estado: $stateError');
        // Como último recurso, forzar el estado
        state = AuthState.unauthenticated;
      }
      
      // Re-lanzar el error para que el UI pueda manejarlo
      rethrow;
    }
  }
}

// Provider para acceder al usuario actual
// Ahora simplemente redirige al userProvider
final currentUsuarioProvider = Provider<UserModel?>((ref) {
  final user = ref.watch(userProvider);
  print("currentUsuarioProvider llamado - usuario: ${user?.nombre ?? 'null'}");
  return user;
});
