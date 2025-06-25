import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasource/api/providers/pasaje_remote_datasource_provider.dart';
import '../../../data/repositories_impl/pasaje_repository_impl.dart';
import '../pasaje_repository.dart';

final pasajeRepositoryProvider = Provider<PasajeRepository>((ref) {
  final remoteDatasource = ref.watch(pasajeRemoteDatasourceProvider);
  return PasajeRepositoryImpl(remoteDatasource: remoteDatasource);
});
