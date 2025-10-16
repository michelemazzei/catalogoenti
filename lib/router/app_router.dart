import 'package:catalogoenti/features/dashboard/ui/dashboard_sreen.dart';
import 'package:catalogoenti/features/place_holder/ui/placeholder_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
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
