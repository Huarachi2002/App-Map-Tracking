import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/criptomonedas_provider.dart';
import '../providers/tipo_cambio_cripto_provider.dart';

class CargarTarjetaPage extends ConsumerStatefulWidget {
  const CargarTarjetaPage({super.key});

  @override
  ConsumerState<CargarTarjetaPage> createState() => _CargarTarjetaPageState();
}

class _CargarTarjetaPageState extends ConsumerState<CargarTarjetaPage> {
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _tipoCambioController = TextEditingController();
  final TextEditingController _saldoController = TextEditingController();
  final TextEditingController _monedaController = TextEditingController(text: 'BOB');

  String? selectedCripto;
  double saldoTarjeta = 150.50;
  double monto = 0.0;

  @override
  void initState() {
    super.initState();
    _saldoController.text = 'Bs ${saldoTarjeta.toStringAsFixed(2)}';

    // Escuchar cambios en el monto sin setState innecesario
    _montoController.addListener(_onMontoChanged);
  }

  void _onMontoChanged() {
    final newMonto = double.tryParse(_montoController.text.replaceAll(',', '.')) ?? 0.0;
    if (newMonto != monto) {
      monto = newMonto;
      // Solo actualizar si realmente cambió
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _montoController.removeListener(_onMontoChanged);
    _montoController.dispose();
    _tipoCambioController.dispose();
    _saldoController.dispose();
    _monedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: _buildContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final criptoAsync = ref.watch(criptomonedasProvider);

    return criptoAsync.when(
      data: (criptos) {
        // Inicializar selectedCripto solo una vez
        if (criptos.isNotEmpty && selectedCripto == null) {
          selectedCripto = criptos.first.simbolo;
        }

        final simbolos = criptos.map((c) => c.simbolo).toList();
        final dropdownValue = simbolos.contains(selectedCripto) ? selectedCripto : null;

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
              controller: _montoController,
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
              // Remover onChanged que causaba el bucle
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
                      setState(() {
                        selectedCripto = value;
                      });
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
              controller: _monedaController,
            ),
            const SizedBox(height: 16),
            _buildTipoCambio(dropdownValue),
            const SizedBox(height: 16),
            TextField(
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Saldo actual de tarjeta',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
              controller: _saldoController,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Cargar crédito'),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildTipoCambio(String? dropdownValue) {
    if (dropdownValue == null) return const SizedBox.shrink();

    final tipoCambioAsync = ref.watch(tipoCambioCriptoProvider({'origen': dropdownValue, 'destino': 'BOB'}));

    return tipoCambioAsync.when(
      data: (tipoCambio) {
        final conversion = monto * tipoCambio;
        final text = '1 ${dropdownValue} = ${tipoCambio.toStringAsFixed(4)} BOB\nTotal: Bs ${conversion.toStringAsFixed(2)}';

        // Solo actualizar si el texto cambió
        if (_tipoCambioController.text != text) {
          _tipoCambioController.text = text;
        }

        return TextField(
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Tipo de cambio',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.currency_exchange),
          ),
          controller: _tipoCambioController,
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: LinearProgressIndicator(),
      ),
      error: (e, _) {
        if (_tipoCambioController.text != 'Error al obtener tipo de cambio') {
          _tipoCambioController.text = 'Error al obtener tipo de cambio';
        }
        return TextField(
          enabled: false,
          decoration: const InputDecoration(
            labelText: 'Tipo de cambio',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.currency_exchange),
          ),
          controller: _tipoCambioController,
        );
      },
    );
  }
}