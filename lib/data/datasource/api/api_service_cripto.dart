import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceCripto {
  Future<Map<String, dynamic>> get(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error al obtener datos externos: ${response.statusCode}');
    }
  }
}
