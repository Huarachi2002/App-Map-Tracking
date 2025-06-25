// import '../../models/tarjeta_model.dart';
// import '../../services/api_service.dart';
// import '../../config/constants.dart';
//
// class TarjetaRemoteDatasource {
//   final ApiService _apiService;
//   TarjetaRemoteDatasource({ApiService? apiService}) : _apiService = apiService ?? ApiService(baseUrl: baseUrl);
//
//   Future<TarjetaModel> getTarjetaByCliente(String idCliente) async {
//     final response = await _apiService.get('tarjeta/cliente-tarjeta/$idCliente');
//     if (response['data'] != null) {
//       return TarjetaModel.fromJson(response['data']);
//     }
//     throw Exception('No se pudo obtener la tarjeta del cliente');
//   }
// }
