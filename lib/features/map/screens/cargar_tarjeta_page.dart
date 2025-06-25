import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../providers/criptomonedas_provider.dart';
import '../providers/tarjeta_provider.dart';
import '../../../data/datasource/api/criptomoneda_api_datasource.dart';

final selectedCriptoProvider = StateProvider<String?>((ref) => null);

class CargarTarjetaPage extends ConsumerStatefulWidget {
  const CargarTarjetaPage({super.key});

  @override
  ConsumerState<CargarTarjetaPage> createState() => _CargarTarjetaPageState();
}

class _CargarTarjetaPageState extends ConsumerState<CargarTarjetaPage> {
  final TextEditingController montoController = TextEditingController();
  final TextEditingController saldoController = TextEditingController(text: 'Bs 150.50');
  final TextEditingController monedaController = TextEditingController(text: 'BOB');

  double? tipoCambio;
  bool tipoCambioLoading = false;
  String? tipoCambioError;

  bool _recargando = false;
  String? _recargaRespuesta;

  @override
  void dispose() {
    montoController.dispose();
    saldoController.dispose();
    monedaController.dispose();
    super.dispose();
  }

  Future<void> _fetchTipoCambio(String origen) async {
    setState(() {
      tipoCambioLoading = true;
      tipoCambioError = null;
    });
    try {
      final service = CriptomonedaApiDatasource();
      final value = await service.getTipoCambioCripto(origen, 'BOB');
      setState(() {
        tipoCambio = value;
        tipoCambioLoading = false;
      });
    } catch (e) {
      setState(() {
        tipoCambioError = 'Error al obtener tipo de cambio';
        tipoCambioLoading = false;
      });
    }
  }

  Future<void> _recargarCredito(double montoBOB, double criptoEquivalente, String tipoCripto, double tasaConversion) async {
    setState(() {
      _recargando = true;
      _recargaRespuesta = null;
    });
    try {
      // Aquí debes obtener el id del cliente autenticado
      final user = ref.watch(userProvider);
      final idCliente = user?.id;
      final tarjetaAsync = idCliente != null ? ref.watch(tarjetaByClienteProvider(idCliente)) : null;
      // Aquí deberías obtener el token real del usuario autenticado
      final token = 'TOKEN_DEL_USUARIO';
      final idTarjeta = tarjetaAsync?.maybeWhen(data: (t) => t.codigo, orElse: () => null);
      final response = await CriptomonedaApiDatasource().recargarTarjeta(


    // Parámetros para el pago
        idTarjeta: idTarjeta?? '',
        montoCripto: criptoEquivalente,
        tipoCripto: tipoCripto,
        tasaConversion: tasaConversion,
        token: token,
      );
      setState(() {
        _recargando = false;
        _recargaRespuesta = 'Recarga exitosa: ${response.toString()}';
      });
    } catch (e) {
      setState(() {
        _recargando = false;
        _recargaRespuesta = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final criptoAsync = ref.watch(criptomonedasProvider);
    final selectedCripto = ref.watch(selectedCriptoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargar Tarjeta'),
        backgroundColor: const Color(0xFF0093E9),
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: criptoAsync.when(
                  data: (criptos) {
                    final simbolos = criptos.map((c) => c.simbolo).toList();
                    if (simbolos.isNotEmpty && (selectedCripto == null || !simbolos.contains(selectedCripto))) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ref.read(selectedCriptoProvider.notifier).state = simbolos.first;
                        _fetchTipoCambio(simbolos.first);
                      });
                    }
                    final dropdownValue = simbolos.contains(selectedCripto) ? selectedCripto : null;
                    double monto = double.tryParse(montoController.text.replaceAll(',', '.')) ?? 0.0;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        const Text(
                          'Monto a cargar',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: montoController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '0.00',
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                          onChanged: (_) {
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Text('Cripto:', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 16),
                            DropdownButton<String>(
                              value: dropdownValue,
                              items: simbolos.map((simbolo) => DropdownMenuItem(
                                value: simbolo,
                                child: Text(simbolo, style: const TextStyle(fontSize: 18)),
                              )).toList(),
                              onChanged: (value) {
                                if (value != null && value != selectedCripto) {
                                  ref.read(selectedCriptoProvider.notifier).state = value;
                                  _fetchTipoCambio(value);
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: 'Moneda',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.monetization_on),
                          ),
                          controller: monedaController,
                        ),
                        const SizedBox(height: 16),
                        _buildTipoCambioManual(dropdownValue, monto),
                        const SizedBox(height: 16),
                        TextField(
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: 'Saldo actual de tarjeta',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.credit_card),
                          ),
                          controller: saldoController,
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _recargando || tipoCambio == null || dropdownValue == null
                                ? null
                                : () {
                                    final montoBOB = double.tryParse(montoController.text.replaceAll(',', '.')) ?? 0.0;
                                    final criptoEquivalente = tipoCambio! > 0 ? montoBOB / tipoCambio! : 0.0;
                                    _recargarCredito(montoBOB, criptoEquivalente, dropdownValue, tipoCambio!);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _recargando
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                  )
                                : const Text('Cargar crédito'),
                          ),
                        ),
                        if (_recargaRespuesta != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              _recargaRespuesta!,
                              style: TextStyle(
                                color: _recargaRespuesta!.startsWith('Error') ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipoCambioManual(String? dropdownValue, double monto) {
    if (tipoCambioLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: LinearProgressIndicator(),
      );
    }
    if (tipoCambioError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          tipoCambioError!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    if (dropdownValue == null || tipoCambio == null) {
      return const SizedBox.shrink();
    }
    // Ahora el usuario ingresa monto en BOB y calculamos el equivalente en cripto
    final criptoEquivalente = tipoCambio! > 0 ? monto / tipoCambio! : 0.0;
    final text = 'Bs ${monto.toStringAsFixed(2)} = ${criptoEquivalente.toStringAsFixed(6)} $dropdownValue\n1 $dropdownValue = ${tipoCambio!.toStringAsFixed(4)} BOB';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}