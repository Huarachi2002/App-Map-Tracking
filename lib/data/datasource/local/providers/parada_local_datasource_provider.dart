import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../parada_local_datasource.dart';
import 'isar_provider.dart';

final paradaLocalDatasourceProvider = FutureProvider<ParadaLocalDatasource>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return ParadaLocalDatasource(isar);
}); 