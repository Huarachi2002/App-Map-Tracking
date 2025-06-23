import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories_impl/parada_repository_impl.dart';
import '../../../data/datasource/api/parada_api_datasource.dart';
import '../../../data/datasource/local/providers/parada_local_datasource_provider.dart';
import '../parada_repository.dart';

final paradaRepositoryProvider = FutureProvider<ParadaRepository>((ref) async {
  final api = ParadaApiDataSourceImpl();
  final local = await ref.watch(paradaLocalDatasourceProvider.future);
  
  return ParadaRepositoryImpl(api, local);
}); 