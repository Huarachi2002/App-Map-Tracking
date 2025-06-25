import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/providers/criptomoneda_repository_provider.dart';

final tipoCambioCriptoProvider = FutureProvider.family<double, Map<String, String>>((ref, params) async {
  final repo = ref.watch(criptomonedaRepositoryProvider);
  final origen = params['origen'] ?? 'USDT';
  final destino = params['destino'] ?? 'BOB';
  return await repo.getTipoCambioCripto(origen, destino);
});
