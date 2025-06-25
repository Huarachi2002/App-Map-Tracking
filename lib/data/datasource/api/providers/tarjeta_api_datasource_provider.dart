import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../tarjeta_api_datasource.dart';

final tarjetaApiDatasourceProvider = Provider<TarjetaApiDatasource>((ref) {
  return TarjetaApiDatasource();
});
