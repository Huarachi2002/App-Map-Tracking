import 'package:app_map_tracking/features/auth/models/user_model.dart';
import 'package:app_map_tracking/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/constants.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

// Provider para almacenar el usuario actual
final userProvider = StateProvider<Usuario?>((ref) => null);

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ApiService(baseUrl: baseUrl), ref);
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;
  final Ref _ref;

  AuthStateNotifier(this._apiService, this._ref) : super(AuthState.initial);
  
  // El usuario ahora lo obtenemos directamente del userProvider
  Usuario? get user => _ref.read(userProvider);  Future<void> login(String email, String password) async {
    try {
      state = AuthState.loading;
      final data = {
        'correo': email,
        'contrasena': password,
      };
      final response = await _apiService.post('auth/sign-in', data);
      
      print("API Response: $response");
      print("Response data structure: ${response['data']}");
      
      if (response['data'] != null) {
        // Crear el usuario a partir de la respuesta
        final usuario = Usuario.fromJson(response['data'], response['data']['token']);
        print("Usuario creado: ${usuario.nombre}, ${usuario.correo}, ${usuario.tipo}");
        
        // Actualizar el userProvider con el nuevo usuario
        _ref.read(userProvider.notifier).state = usuario;
        
        // Cambiar el estado de autenticación
        state = AuthState.authenticated;
      } else {
        print("Error: No se encontró 'data' en la respuesta");
        state = AuthState.error;
        throw Exception('Login failed: No data in response');
      }
    } catch (e) {
      print("Error en login: $e");
      state = AuthState.error;
      throw Exception('Login failed: $e');
    }
  }
  void logout() {
    // Limpiar el usuario en el provider
    _ref.read(userProvider.notifier).state = null;
    state = AuthState.unauthenticated;
  }
}

// Provider para acceder al usuario actual
// Ahora simplemente redirige al userProvider
final currentUsuarioProvider = Provider<Usuario?>((ref) {
  final user = ref.watch(userProvider);
  print("currentUsuarioProvider llamado - usuario: ${user?.nombre ?? 'null'}");
  return user;
});
