import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/providers/tarjeta_repository_provider.dart';
import '../../../data/models/tarjeta_model.dart';

final tarjetaByClienteProvider = FutureProvider.family.autoDispose<TarjetaModel, String>((ref, idCliente) async {
  final repo = ref.watch(tarjetaRepositoryProvider);
  return repo.getTarjetaByCliente(idCliente);
});
