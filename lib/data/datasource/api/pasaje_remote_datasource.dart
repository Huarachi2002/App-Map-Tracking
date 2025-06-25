import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/constants.dart';
import 'api_service.dart';

class PasajeRemoteDatasource {
  final ApiService _apiService;
  PasajeRemoteDatasource({ApiService? apiService}) : _apiService = apiService ?? ApiService(baseUrl: baseUrl);

  Future<double> getPrecioPasaje(String idEntidad) async {
    final response = await _apiService.get('entidad-operadora/tarifa/$idEntidad');
    if (response['data'] != null && response['data']['tarifa'] != null) {
      print("consulta pasaje: $response");
      return (response['data']['tarifa'] as num).toDouble();
    }
    throw Exception('No se pudo obtener el precio del pasaje');
  }

  Future<Map<String, dynamic>> pagarConTarjeta({
    required String idTarjeta,
    required double monto,
    required String idMicro,
  }) async {

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');

    final response = await _apiService.post(
      'tarjeta/pago',
      {
        'id_tarjeta': idTarjeta,
        'monto': monto,
        'id_micro': idMicro,
      },
      headers: {'auth-token': authToken ?? ''},
    );
    return response;
  }
}
