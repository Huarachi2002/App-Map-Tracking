import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasource/api/providers/tarjeta_api_datasource_provider.dart';
import '../../../data/datasource/local/tarjeta_local_datasource.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PagoState {
  final bool isLoading;
  final String? error;
  final bool success;
  PagoState({this.isLoading = false, this.error, this.success = false});

  PagoState copyWith({bool? isLoading, String? error, bool? success}) => PagoState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
        success: success ?? this.success,
      );
}

class PagoNotifier extends StateNotifier<PagoState> {
  final TarjetaLocalDatasource localDatasource;
  final dynamic apiDatasource;
  PagoNotifier({required this.localDatasource, required this.apiDatasource}) : super(PagoState());

  Future<void> pagarConTarjeta({required String codigoTarjeta, required double monto}) async {
    state = PagoState(isLoading: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('auth_token') ?? '';
      // Llama al endpoint de pago
      final response = await apiDatasource.pagarConTarjeta(
        codigoTarjeta: codigoTarjeta,
        monto: monto,
        headers: {'auth-token': authToken},
      );
      // Actualiza el saldo local si el pago fue exitoso
      if (response['success'] == true && response['nuevoSaldo'] != null) {
        final tarjeta = await localDatasource.getTarjetaByCodigo(codigoTarjeta);
        if (tarjeta != null) {
          tarjeta.saldoActual = response['nuevoSaldo'];
          await localDatasource.updateTarjeta(tarjeta);
        }
        state = PagoState(success: true);
      } else {
        state = PagoState(error: response['message'] ?? 'Error en el pago');
      }
    } catch (e) {
      state = PagoState(error: e.toString());
    }
  }

  Future<void> pagarTarjeta({
    required String idTarjeta,
    required double monto,
    required String idMicro,
  }) async {
    state = PagoState(isLoading: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('auth_token') ?? '';
      final response = await apiDatasource.pagarTarjeta(
        idTarjeta: idTarjeta,
        monto: monto,
        idMicro: idMicro,
        apiKey: authToken,
      );
      if (response['success'] == true) {
        // Descontar el monto del saldo local
        final tarjeta = await localDatasource.getTarjetaByCodigo(idTarjeta);
        if (tarjeta != null) {
          tarjeta.saldoActual -= monto;
          await localDatasource.updateTarjeta(tarjeta);
        }
        state = PagoState(success: true);
      } else {
        state = PagoState(error: response['message'] ?? 'Error en el pago');
      }
    } catch (e) {
      state = PagoState(error: e.toString());
    }
  }
}

final pagoProvider = StateNotifierProvider<PagoNotifier, PagoState>((ref) {
  final isar = Isar.getInstance();
  final local = TarjetaLocalDatasource(isar!);
  final api = ref.watch(tarjetaApiDatasourceProvider);
  return PagoNotifier(localDatasource: local, apiDatasource: api);
});
