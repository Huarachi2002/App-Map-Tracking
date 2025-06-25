import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/providers/criptomoneda_repository_provider.dart';
import '../../../domain/entities/criptomoneda.dart';

final criptomonedasProvider = FutureProvider.autoDispose<List<Criptomoneda>>((ref) async {
  final repo = ref.watch(criptomonedaRepositoryProvider);
  return await repo.getCriptomonedas();
});
