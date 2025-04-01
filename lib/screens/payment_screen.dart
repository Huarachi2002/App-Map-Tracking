import 'package:flutter/material.dart';
import 'dart:async';
import '../models/payment_transaction.dart';
import '../services/nfc_service.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String crypptoType;
  const PaymentScreen(
      {super.key, required this.amount, required this.crypptoType});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final NfcService _nfcService = NfcService();
  bool _isNFCAvailable = false;
  bool _isProcessing = false;
  String _statusMessage = 'Preparando pago...';

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
          ? 'Presiona para iniciar el pago NFC'
          : 'NFC no disponible en este dispositivo';
    });
  }

  Future<void> _initiatePayment() async {
    if (!_isNFCAvailable || _isProcessing) return;
    setState(() {
      _isProcessing = true;
      _statusMessage = 'Acerca tu dispositivo al lector de pago...';
    });

    try {
      final transaction = PaymentTransaction(
        id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        amount: widget.amount,
        currency: 'BS', // Moneda local
        timestamp: DateTime.now(),
        status: 'pending',
        cryptoType: widget.crypptoType,
        cryptoAmount: widget.amount, // En una app real, se haría la conversión
        walletId: 'wallet_user123',
      );

      final sucess = await _nfcService.sendPayment(transaction);

      setState(() {
        _isProcessing = false;
        _statusMessage = sucess
            ? '¡Pago completado con éxito!'
            : 'Error al procesar el pago. Inténtalo de nuevo.';
      });

      if (sucess) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context, transaction);
          }
        });
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _statusMessage = 'Error al iniciar el pago: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago NFC'),
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contactless,
              size: 100,
              color: _isProcessing
                  ? Colors.blue
                  : _isNFCAvailable
                      ? Colors.green
                      : Colors.red,
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Detalles del Pago',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Monto: '),
                        Text(
                          'Bs/ ${widget.amount.toStringAsFixed(2)}',
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
                        const Text('Metodo: '),
                        Text(
                          widget.crypptoType,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: _isProcessing
                    ? Colors.blue[700]
                    : (_statusMessage.contains('exito')
                        ? Colors.green
                        : Colors.black87),
              ),
            ),
            const SizedBox(height: 30),
            if (_isNFCAvailable &&
                !_isProcessing &&
                !_statusMessage.contains('exito'))
              ElevatedButton(
                onPressed: _initiatePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Iniciar Pago',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            if (_isProcessing) const CircularProgressIndicator()
          ],
        ),
      )),
    );
  }
}
