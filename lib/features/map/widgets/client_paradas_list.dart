import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/parada_model.dart';
import '../../providers/parada_provider.dart';

class ClientParadasList extends ConsumerStatefulWidget {
  final VoidCallback? onClose;

  const ClientParadasList({
    super.key,
    this.onClose,
  });

  @override
  ConsumerState<ClientParadasList> createState() => _ClientParadasListState();
}

class _ClientParadasListState extends ConsumerState<ClientParadasList> {
  bool _isVisible = true; // Comenzar visible para mostrar paradas automáticamente

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final paradas = ref.watch(selectedParadasProvider);
    final rutaId = ref.watch(selectedRutaIdProvider);

    if (paradas.isEmpty) {
      return const SizedBox.shrink();
    }

    // Si no está visible, mostrar solo un botón pequeño para expandir
    if (!_isVisible) {
      return Container(
        alignment: Alignment.centerRight,
        child: FloatingActionButton.small(
          onPressed: _toggleVisibility,
          backgroundColor: Colors.blue,
          child: const Icon(Icons.list, color: Colors.white),
          tooltip: 'Mostrar paradas (${paradas.length})',
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.bus_alert,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Paradas de la Ruta',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: _toggleVisibility,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Cerrar lista',
                ),
              ],
            ),
          ),
          
          // Lista de paradas
          Container(
            constraints: const BoxConstraints(maxHeight: 200), // Reducido para que no ocupe tanto espacio
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              itemCount: paradas.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final parada = paradas[index];
                return _ParadaListItem(
                  parada: parada,
                  index: index + 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ParadaListItem extends StatelessWidget {
  final ParadaModel parada;
  final int index;

  const _ParadaListItem({
    required this.parada,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Número de orden/círculo
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue.shade300,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                index.toString(), // Usar índice ya que no hay campo orden
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Información de la parada
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  parada.nombre,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                if (parada.tiempo.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.blue[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Tiempo: ${parada.tiempo}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${parada.latitud.toStringAsFixed(6)}, ${parada.longitud.toStringAsFixed(6)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Icono de parada
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.bus_alert,
              size: 16,
              color: Colors.blue.shade600,
            ),
          ),
        ],
      ),
    );
  }
} 