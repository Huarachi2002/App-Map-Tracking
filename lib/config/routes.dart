import 'package:app_map_tracking/features/auth/screens/login_page.dart';
import 'package:app_map_tracking/features/map/screens/client_map_page.dart';
import 'package:app_map_tracking/features/map/screens/employee_map_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(initialLocation: '/home-client', routes: [
  GoRoute(
    path: '/home-client',
    builder: (context, state) => const ClientMapPage(),
  ),
  GoRoute(
    path: '/home-employee',
    builder: (context, state) => const EmployeeMapPage(),
  ),
  GoRoute(
    path: '/sign-in',
    builder: (context, state) => const LoginPage(),
  )
]);
