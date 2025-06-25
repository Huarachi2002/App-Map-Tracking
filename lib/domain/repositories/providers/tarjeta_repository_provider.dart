import 'package:app_map_tracking/data/datasource/local/providers/tarjeta_local_datasource_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasource/api/providers/tarjeta_api_datasource_provider.dart';
import '../../../data/datasource/local/tarjeta_local_datasource.dart';
import '../../../data/repositories_impl/tarjeta_repository_impl.dart';
import '../tarjeta_repository.dart';
import '../../../data/datasource/local/providers/isar_provider.dart';

final tarjetaRepositoryProvider = Provider<TarjetaRepository>((ref) {
  final apiDatasource = ref.watch(tarjetaApiDatasourceProvider);
  final localDatasource = ref.watch(tarjetaLocalDataSourceProvider).requireValue;
  return TarjetaRepositoryImpl(apiDatasource: apiDatasource, localDatasource: localDatasource);
});
