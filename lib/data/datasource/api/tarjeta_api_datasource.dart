import '../../../config/constants.dart';

import '../../models/tarjeta_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class TarjetaApiDatasource {
  final ApiService _apiService;
  TarjetaApiDatasource({ApiService? apiService}) : _apiService = apiService ?? ApiService(baseUrl: baseUrl);

  Future<TarjetaModel> getTarjetaByCliente(String idCliente) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');
    final response = await _apiService.get(
      'tarjeta/cliente-tarjeta/$idCliente',
      headers: {'auth-token': authToken ?? ''},
    );
    if (response['data'] != null) {
      //TODO: modificar para obtener mas tarjetas
      return TarjetaModel.fromJson(response['data'][0]);
    }
    throw Exception('No se pudo obtener la tarjeta del cliente');
  }
}
