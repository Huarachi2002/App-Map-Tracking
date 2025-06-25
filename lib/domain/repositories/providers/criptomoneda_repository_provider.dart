import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasource/api/providers/criptomoneda_api_datasource_provider.dart';
import '../../../data/repositories_impl/criptomoneda_repository_impl.dart';
import '../criptomoneda_repository.dart';

final criptomonedaRepositoryProvider = Provider<CriptomonedaRepository>((ref) {
  final api = ref.watch(criptomonedaApiDatasourceProvider);
  return CriptomonedaRepositoryImpl(apiDatasource: api);
});
