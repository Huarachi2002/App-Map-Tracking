import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/constants.dart' as constants;
import '../../models/parada_model.dart';

abstract class ParadaApiDataSource {
  Future<List<ParadaModel>> getParadasByRutaId(String rutaId);
}

class ParadaApiDataSourceImpl implements ParadaApiDataSource {
  final http.Client httpClient;

  ParadaApiDataSourceImpl({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  @override
  Future<List<ParadaModel>> getParadasByRutaId(String rutaId) async {
    try {
      print('🚏 Obteniendo paradas para ruta ID: $rutaId');
      
      final response = await httpClient.get(
        Uri.parse('${constants.baseUrl}/parada/$rutaId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('📡 Respuesta API paradas - Status: ${response.statusCode}');
      print('📡 Respuesta API paradas - Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Verificar el formato correcto de la respuesta según el ejemplo del usuario
        if (data['statusCode'] == 200 && data['data'] != null && data['data']['paradas'] != null) {
          final List<dynamic> paradasJson = data['data']['paradas'];
          
          final List<ParadaModel> paradas = paradasJson
              .map((json) => ParadaModel.fromJson(json))
              .toList();
          
          print('✅ Paradas obtenidas exitosamente: ${paradas.length} paradas');
          return paradas;
        } else {
          print('⚠️ Formato de respuesta inesperado: ${data}');
          return [];
        }
      } else {
        print('❌ Error en la respuesta: ${response.statusCode} - ${response.body}');
        throw Exception('Error al obtener paradas: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Excepción al obtener paradas: $e');
      throw Exception('Error de conexión al obtener paradas: $e');
    }
  }
} 