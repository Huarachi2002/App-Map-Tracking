import 'package:flutter/material.dart';
import 'dart:async';
import '../models/payment_transaction.dart';
import '../services/nfc_service.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final NfcService _nfcService = NfcService();
  bool _isNFCAvailable = false;
  bool _isReading = false;
  String _statusMessage = 'Verificando NFC...';
  PaymentTransaction? _lastTransaction;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkNFCAvailability();
  }

  Future<void> _checkNFCAvailability() async {
    final isAvailable = await _nfcService.isNFCAvailable();
    setState(() {
      _isNFCAvailable = isAvailable;
      _statusMessage = isAvailable
          ? 'Lector listo. Presiona Iniciar para detectar pagos.'
          : 'NFC no disponible en este dispositivo';
    });
  }

  Future<void> _startReaderMode() async {
    if (!_isNFCAvailable || _isReading) return;

    setState(() {
      _isReading = true;
      _statusMessage = 'Esperando pago... Acerca la tarjeta o dispositivo';
      _lastTransaction = null;
    });

    try {
      final transaction = await _nfcService.startReaderMode();

      setState(() {
        _isReading = false;
        if (transaction != null) {
          _lastTransaction = transaction;
          _statusMessage = '¡Pago recibido!';
        } else {
          _statusMessage = 'No se detectó ningún pago. Intenta de nuevo.';
        }
      });
    } catch (e) {
      setState(() {
        _isReading = false;
        _statusMessage = 'Error al leer el pago: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lector de Pagos NFC'),
        backgroundColor: Colors.indigo[800],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.nfc,
                size: 100,
                color: _isReading
                    ? Colors.blue
                    : _isNFCAvailable
                        ? Colors.green
                        : Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: _isReading
                        ? Colors.blue[700]
                        : _lastTransaction != null
                            ? Colors.green
                            : Colors.black87),
              ),
              const SizedBox(height: 30),
              if (_lastTransaction != null)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Detalles de la Transacción',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Criptomoneda: '),
                            Text(
                              _lastTransaction!.cryptoType,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Fecha:'),
                            Text(
                              '${_lastTransaction!.timestamp.day}/${_lastTransaction!.timestamp.month}/${_lastTransaction!.timestamp.year} ${_lastTransaction!.timestamp.hour}:${_lastTransaction!.timestamp.minute}',
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              if (_isNFCAvailable && !_isReading)
                ElevatedButton(
                  onPressed: _startReaderMode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[800],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'Ininiciar Lectura',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              if (_isReading)
                Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      'Esperando pago...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[700],
                      ),
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
