import 'package:app_map_tracking/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final currentUser = ref.watch(userProvider); // Usar directamente el userProvider

    print("AppDrawer - Estado de autenticación: $authState");
    print("AppDrawer - Usuario actual: ${currentUser?.nombre ?? 'null'}");

    final isAuthenticated = authState == AuthState.authenticated;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'App Map Tracking',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),                if (isAuthenticated && currentUser != null) ...[
                  Text(
                    currentUser.nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    currentUser.correo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Tipo: ${currentUser.tipo}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ] else
                  const Text(
                    'No has iniciado sesión',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
          ),          // Divisor después del encabezado
          const Divider(),
          
          if (!isAuthenticated)
            ListTile(
              leading: const Icon(Icons.login, color: Colors.blue),
              title: const Text('Iniciar Sesión'),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                context.go('/sign-in');
              },
            )
          else
            Column(
              children: [
                // Opción de mapa según tipo de usuario
                ListTile(
                  leading: const Icon(Icons.map, color: Colors.green),
                  title: Text(currentUser?.tipo == 'CLIENTE' 
                      ? 'Ver Mapa Cliente' 
                      : 'Ver Mapa Empleado'),
                  subtitle: Text(currentUser?.tipo == 'CLIENTE'
                      ? 'Ver ubicación de micros'
                      : 'Compartir tu ubicación'),
                  onTap: () {
                    Navigator.pop(context);
                    if (currentUser?.tipo == 'CLIENTE') {
                      context.go('/home-client');
                    } else {
                      context.go('/home-employee');
                    }
                  },
                ),
                
                const Divider(),
                
                // Sección de perfil
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 8.0),
                  child: Text(
                    'Mi cuenta',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: const Text('Mi Perfil'),
                  onTap: () {
                    Navigator.pop(context);
                    // Implementar navegación a perfil
                    // context.go('/profile');
                  },
                ),
                
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.grey),
                  title: const Text('Configuración'),
                  onTap: () {
                    Navigator.pop(context);
                    // Implementar navegación a configuración
                    // context.go('/settings');
                  },
                ),
                  const Divider(),
                
                // PARA DESARROLLO: Permite cambiar entre los modos
                if (currentUser != null)
                  ListTile(
                    leading: const Icon(Icons.swap_horiz, color: Colors.purple),
                    title: Text('Cambiar a ${currentUser.tipo == 'CLIENTE' ? 'Empleado' : 'Cliente'}'),
                    subtitle: const Text('Solo para pruebas'),
                    onTap: () {
                      Navigator.pop(context);
                      if (currentUser.tipo == 'CLIENTE') {
                        context.go('/home-employee');
                      } else {
                        context.go('/home-client');
                      }
                    },
                  ),
                
                const Divider(),
                
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Cerrar Sesión', 
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    ref.read(authStateProvider.notifier).logout();
                    Navigator.pop(context);
                    context.go('/sign-in');
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
