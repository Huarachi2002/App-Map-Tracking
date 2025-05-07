import 'package:app_map_tracking/features/auth/screens/login_page.dart';
import 'package:go_router/go_router.dart';

import '../features/map/screens/map_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder:(context, state) =>  const MapPage(),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const LoginPage(),
    )
  ]
);