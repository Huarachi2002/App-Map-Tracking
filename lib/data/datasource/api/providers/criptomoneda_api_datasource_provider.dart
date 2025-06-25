import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../criptomoneda_api_datasource.dart';

final criptomonedaApiDatasourceProvider = Provider<CriptomonedaApiDatasource>((ref) {
  return CriptomonedaApiDatasource();
});
