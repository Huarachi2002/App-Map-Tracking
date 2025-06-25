import '../../../config/constants.dart';
import 'api_service_cripto.dart';

import '../../models/criptomoneda_model.dart';
import 'api_service.dart';

class CriptomonedaApiDatasource {
  final ApiService _apiService;
  final ApiServiceCripto _apiServiceCripto = ApiServiceCripto();
  CriptomonedaApiDatasource({ApiService? apiService}) : _apiService = apiService ?? ApiService(baseUrl: baseUrl);

  Future<List<CriptomonedaModel>> getCriptomonedas() async {
    final response = await _apiService.get('criptomoneda');
    final data = response['data']?['criptomonedas'] as List?;
    if (data == null) throw Exception('No se encontraron criptomonedas');
    return data.map((e) => CriptomonedaModel.fromJson(e)).toList();
  }
  
  Future<double> getTipoCambioCripto(String origen, String destino) async {
    String cambioSolicitado = '$origen-$destino'.toUpperCase();

    final url = 'https://data-api.coindesk.com/index/cc/v1/latest/tick';
    final params = {
      'market': 'cadli',
      'instruments': cambioSolicitado,
      'apply_mapping': 'true',
      'api_key': 'd2a4376390e09e7ae910a0fc5c05cf294101fb03055d8365980a4b71bb3e3157',
    };
    final uri = Uri.parse(url).replace(queryParameters: params);
    final response = await _apiServiceCripto.get(uri.toString());
    final data = response['Data']?[cambioSolicitado];
    if (data == null || data['VALUE'] == null) {
      throw Exception('No se pudo obtener el tipo de cambio $cambioSolicitado');
    }
    return (data['VALUE'] as num).toDouble();
  }
}
