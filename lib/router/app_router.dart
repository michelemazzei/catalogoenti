import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/placeholder_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/enti',
      name: 'enti',
      builder: (context, state) => const PlaceholderScreen(
        title: 'Enti',
        message: 'La pagina Enti non è ancora disponibile.',
      ),
    ),
    GoRoute(
      path: '/materiali',
      name: 'materiali',
      builder: (context, state) => const PlaceholderScreen(
        title: 'Materiali',
        message: 'La pagina Materiali non è ancora disponibile.',
      ),
    ),
    GoRoute(
      path: '/interventi',
      name: 'interventi',
      builder: (context, state) => const PlaceholderScreen(
        title: 'Interventi',
        message: 'La pagina Interventi non è ancora disponibile.',
      ),
    ),
  ],
);
