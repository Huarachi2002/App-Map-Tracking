import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/shared_preference_helper.dart';
import '../../../data/datasource/local/providers/entidad_local_datasource_provider.dart';
import '../../../data/datasource/local/providers/ruta_local_datasource_provider.dart';
import '../../../data/datasource/local/providers/isar_provider.dart';
import '../../../data/repositories_impl/entidad_repository_impl.dart';
import '../../../data/repositories_impl/ruta_repository_impl.dart';
import '../../../domain/repositories/providers/entidad_repository_provider.dart';
import '../../../domain/repositories/providers/ruta_repository_provider.dart';
import '../../providers/entidad_provider.dart';
import '../../providers/ruta_provider.dart';
import '../../providers/entidad_id_provider.dart';
import '../../providers/parada_provider.dart';
import '../widgets/client_paradas_list.dart';

class _OptionButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final String heroTag;
  final VoidCallback onPressed;
  final Widget? badge;
  final bool mini;

  const _OptionButton({
    required this.icon,
    required this.backgroundColor,
    required this.heroTag,
    required this.onPressed,
    this.badge,
    this.mini = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: mini,
      heroTag: heroTag,
      backgroundColor: backgroundColor,
      onPressed: onPressed,
      child: Stack(
        children: [
          Icon(icon, color: Colors.white),
          if (badge != null) badge!,
        ],
      ),
    );
  }
}

class ClientOptionsButtons extends ConsumerWidget {
  final Function()? onRouteCleared;

  const ClientOptionsButtons({
    super.key,
    this.onRouteCleared,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paradas = ref.watch(selectedParadasProvider);
    return Positioned(
      top: 120,
      right: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón de mostrar paradas
          if (paradas.isNotEmpty)
            _OptionButton(
              icon: Icons.bus_alert,
              backgroundColor: Colors.blue[700]!,
              heroTag: "paradas_list_btn",
              onPressed: () => _showParadasModal(context),
              badge: Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    '${paradas.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          // Botón de mostrar ubicación actual
          // _OptionButton(
          //   icon: Icons.my_location,
          //   backgroundColor: Colors.green,
          //   heroTag: "current_location_btn",
          //   onPressed: () => _goToCurrentLocation(context, ref),
          //   mini: true,
          // ),
        ],
      ),
    );
  }

  // NUEVA función para mostrar las paradas en un modal
  void _showParadasModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: const ClientParadasList(),
      ),
    );
  }

  // Función para centrar el mapa en la ubicación actual del usuario
  void _goToCurrentLocation(BuildContext context, WidgetRef ref) {
    // Aquí deberías implementar la lógica para centrar el mapa en la ubicación actual
    // Puedes llamar a un método del provider o usar un callback
    // Ejemplo:
    // ref.read(clientMapControllerProvider.notifier).goToCurrentLocation();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad de centrar en ubicación actual no implementada.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}