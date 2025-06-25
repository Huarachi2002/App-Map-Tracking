import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/providers/pasaje_repository_provider.dart';

final pagarPasajeProvider = FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((ref, params) async {
  final repo = ref.watch(pasajeRepositoryProvider);
  final idTarjeta = params['idTarjeta'] as String;
  final monto = params['monto'] as double;
  final idMicro = params['idMicro'] as String;
  return await repo.pagarPasajeConTarjeta(
    idTarjeta: idTarjeta,
    monto: monto,
    idMicro: idMicro,
  );
});
