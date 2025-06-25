import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/pasaje_price_provider.dart';

class CobroPasajePage extends ConsumerStatefulWidget {
  const CobroPasajePage({super.key});

  @override
  ConsumerState<CobroPasajePage> createState() => _CobroPasajePageState();
}

class _CobroPasajePageState extends ConsumerState<CobroPasajePage> {
  int secondsLeft = 30;
  Timer? _timer;
  int qrTimestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      secondsLeft = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft == 1) {
        _refreshQR();
      } else {
        setState(() {
          secondsLeft--;
        });
      }
    });
  }

  void _refreshQR() {
    setState(() {
      qrTimestamp = DateTime.now().millisecondsSinceEpoch;
      secondsLeft = 30;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final entidadId = user?.entidadId;
    final empleadoId = user?.empleadoId;
    final microId = user?.microId;
    final rutaId = user?.rutaAsignada ?? '';
    final nombreLinea = user?.rutaAsignada ?? 'Línea';
    final nombreConductor = user?.nombre ?? '';

    final precioAsync = entidadId != null
        ? ref.watch(pasajePriceProvider(entidadId))
        : const AsyncValue<double>.loading();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0093E9),
              Color(0xF081D9FD),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Nombre de la línea
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                child: Text(
                  nombreLinea,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Nombre del conductor
              Text(
                nombreConductor,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // QR centrado
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: precioAsync.when(
                    data: (precio) {
                      final qrPayload = jsonEncode( {
                        'entidadId': entidadId,
                        'empleadoId': empleadoId,
                        'microId': microId,
                        'precio': precio,
                        'ts': qrTimestamp,
                      });
                      final qrString = qrPayload.toString();
                      return QrImageView(
                        data: qrString,
                        version: QrVersions.auto,
                        size: 220.0,
                        gapless: false,
                        backgroundColor: Colors.white,
                      );
                    },
                    loading: () => const SizedBox(
                      width: 220,
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Container(
                      width: 220,
                      height: 220,
                      color: Colors.red.shade100,
                      child: Center(child: Text('Error al cargar precio', style: TextStyle(color: Colors.red))),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Monto destacado
              precioAsync.when(
                data: (precio) => Text(
                  'Bs ${precio.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                    shadows: [
                      Shadow(
                        color: Colors.white,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                loading: () => const Text('Cargando precio...', style: TextStyle(fontSize: 20, color: Colors.white)),
                error: (e, _) => const Text('Error al cargar precio', style: TextStyle(fontSize: 20, color: Colors.red)),
              ),
              const SizedBox(height: 12),
              // Contador y botón recargar
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer, color: Colors.white70),
                      const SizedBox(width: 6),
                      Text(
                        'QR se actualiza en $secondsLeft s',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ]
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: () {
                      _refreshQR();
                      _startTimer();
                      if (entidadId != null) ref.refresh(pasajePriceProvider(entidadId));
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text('Recargar', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0093E9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
