import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pasaje_remote_datasource.dart';

final pasajeRemoteDatasourceProvider = Provider<PasajeRemoteDatasource>((ref) {
  return PasajeRemoteDatasource();
});
