import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/repositories/providers/pasaje_repository_provider.dart';

final pasajePriceProvider = FutureProvider.family<double, String>((ref, idEntidad) async {
  final repo = ref.watch(pasajeRepositoryProvider);
  return repo.getPrecioPasaje(idEntidad);
});
