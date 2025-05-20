import 'package:app_map_tracking/features/auth/models/user_model.dart';
import 'package:app_map_tracking/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/constants.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ApiService(baseUrl: baseUrl));
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;
  Usuario? _user;

  AuthStateNotifier(this._apiService) : super(AuthState.initial);

  Usuario? get user => _user;

  Future<void> login(String email, String password) async {
    try {
      state = AuthState.loading;
      final data = {
        'correo': email,
        'contrasena': password,
      };
      final response = await _apiService.post('sing-in', data);

      if (response['status'] == 'success') {
        _user = Usuario.fromJson(response['data'], response['token']);
        state = AuthState.authenticated;
      } else {
        state = AuthState.unauthenticated;
      }
    } catch (e) {
      state = AuthState.error;
      throw Exception('Login failed: $e');
    }
  }

  void logout() {
    _user = null;
    state = AuthState.unauthenticated;
  }
}

// Provider para acceder al usuario actual
final currentUsuarioProvider = Provider<Usuario?>((ref) {
  final authNotifier = ref.watch(authStateProvider.notifier);
  return authNotifier.user;
});
