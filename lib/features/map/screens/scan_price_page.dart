import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/tarjeta_provider.dart';
import '../providers/pagar_pasaje_provider.dart';

class ScanPricePage extends ConsumerStatefulWidget {
  const ScanPricePage({super.key});

  @override
  ConsumerState<ScanPricePage> createState() => _ScanPricePageState();
}

class _ScanPricePageState extends ConsumerState<ScanPricePage> {
  String? qrContent;
  Map<String, dynamic>? qrDecoded;
  String? errorMsg;
  bool isScanning = true;
  bool isPaying = false;
  Map<String, dynamic>? pagoResult;
  String? pagoError;

  void _onDetect(BarcodeCapture capture) {
    if (!isScanning) return;
    final Barcode? barcode = capture.barcodes.firstOrNull;
    if (barcode != null && barcode.rawValue != null) {
      setState(() {
        qrContent = barcode.rawValue;
        isScanning = false;
        errorMsg = null;
        qrDecoded = null;
      });
      _processQR(barcode.rawValue!);
    }
  }

  void _processQR(String raw) {
    try {
      // Intentar decodificar como JSON
      Map<String, dynamic> data = jsonDecode(raw);
      // Obtener wallet_address del usuario loggeado
      final user = ref.read(userProvider);
      final wallet = user?.wallet_address ?? user?.wallet_address;
      if (wallet != null) {
        data['wallet_address'] = wallet;
      }
      setState(() {
        qrDecoded = data;
        errorMsg = null;
      });
    } catch (e) {
      setState(() {
        errorMsg = 'El QR no contiene un JSON válido. $raw';
        qrDecoded = null;
      });
    }
  }

  void _restartScan() {
    setState(() {
      qrContent = null;
      qrDecoded = null;
      errorMsg = null;
      isScanning = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final idCliente = user?.id;
    final tarjetaAsync = idCliente != null ? ref.watch(tarjetaByClienteProvider(idCliente)) : null;

    // Parámetros para el pago
    final idTarjeta = tarjetaAsync?.maybeWhen(data: (t) => t.codigo, orElse: () => null);
    final monto = qrDecoded != null ? (qrDecoded!['precio'] as num?)?.toDouble() : null;
    final idMicro = qrDecoded != null ? qrDecoded!['microId'] as String? : null;

    final pagarParams = (idTarjeta != null && monto != null && idMicro != null)
        ? {'idTarjeta': idTarjeta, 'monto': monto, 'idMicro': idMicro}
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        backgroundColor: const Color(0xFF0093E9),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF7DDFFF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isScanning) ...[
              const Padding(
                padding: EdgeInsets.only(top: 24.0, bottom: 12.0),
                child: Text(
                  'Apunta la cámara al código QR',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: MobileScanner(
                      controller: MobileScannerController(),
                      onDetect: _onDetect,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 60),
              if (errorMsg != null) ...[
                const Icon(Icons.error, color: Colors.red, size: 80),
                const SizedBox(height: 24),
                Text(
                  errorMsg!,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 24),
                // Mostrar solo el precio destacado
                if (qrDecoded != null && qrDecoded!['precio'] != null) ...[
                  const Text(
                    'Precio:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 64.0),
                    child: Text(
                      'Bs ${((qrDecoded!['precio'] as num?)?.toStringAsFixed(2) ?? '-')}',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
                // Mensaje de pago
                if (isPaying)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                if (pagoResult != null)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      'Pago realizado: ${pagoResult?['message']}',
                      style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                if (pagoError != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      maxLines: 4,
                      'Error al pagar: $pagoError',
                      style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                const Spacer(),
                // Saldo actual de la tarjeta justo encima de los botones
                if (tarjetaAsync != null)
                  tarjetaAsync.when(
                    data: (tarjeta) => Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: Text(
                        'Saldo actual: Bs ${tarjeta.saldoActual.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: CircularProgressIndicator(),
                    ),
                    error: (e, trace) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('No se pudo obtener el saldo $e ', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                // Botones en línea horizontal abajo
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0, left: 24.0, right: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: (!isPaying && pagoResult == null && pagarParams != null)
                              ? () async {
                                  setState(() {
                                    isPaying = true;
                                    pagoResult = null;
                                    pagoError = null;
                                  });
                                  try {
                                    final result = await ref.read(pagarPasajeProvider(pagarParams).future);
                                    setState(() {
                                      pagoResult = result;
                                      isPaying = false;
                                    });
                                    // Refrescar saldo
                                    if (idCliente != null) {
                                      ref.invalidate(tarjetaByClienteProvider(idCliente));
                                    }
                                  } catch (e) {
                                    setState(() {
                                      pagoError = e.toString();
                                      isPaying = false;
                                    });
                                  }
                                }
                              : null,
                          icon: const Icon(Icons.payment),
                          label: const Text('Realizar Pago'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: isPaying ? null : _restartScan,
                        icon: const Icon(Icons.qr_code_scanner, size: 36, color: Color(0xFF0093E9)),
                        tooltip: 'Escanear otro',
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
