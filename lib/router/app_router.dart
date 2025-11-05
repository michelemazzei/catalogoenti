import 'package:catalogoenti/features/calibrazione/ui/materiali_con_ultima_calibrazione_screen.dart';
import 'package:catalogoenti/features/calibrazione/ui/materiali_da_calibrare_screen.dart';
import 'package:catalogoenti/features/calibrazione/ui/materiali_in_scadenza_screen.dart';
import 'package:catalogoenti/features/contratti/ui/contratti_screen.dart';
import 'package:catalogoenti/features/contratti/ui/contratto_dettaglio_screen.dart';
import 'package:catalogoenti/features/contratti/ui/riepilogo_costi_contratto_screen.dart';
import 'package:catalogoenti/features/dashboard/ui/dashboard_sreen.dart';
import 'package:catalogoenti/features/enti/ui/ente_detail_screen.dart';
import 'package:catalogoenti/features/enti/ui/enti_screen.dart';
import 'package:catalogoenti/features/materiali/ui/materiale_dettaglio_screen.dart';
import 'package:catalogoenti/features/materiali/ui/materiali_raggruppati_per_ente_screen.dart';
import 'package:catalogoenti/features/materiali/ui/materiali_screen.dart';
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
      builder: (context, state) => const EntiScreen(),
      routes: [
        GoRoute(
          name: 'entiDetails',
          path: ':id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return EnteDetailScreen(enteId: id);
          },
        ),
      ],
    ),
    GoRoute(
      name: 'materialiPerEnte',
      path: '/materiali/ente/:enteId',
      builder: (context, state) {
        final enteIdString = state.pathParameters['enteId'];
        final enteId = int.tryParse(enteIdString ?? '');
        final enteNome = state.extra as String?;

        return MaterialiScreen(enteId: enteId, enteNome: enteNome);
      },
    ),

    GoRoute(
      name: 'materialeDettaglio',
      path: '/materiali/dettaglio/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return MaterialeDettaglioScreen(id: id);
      },
    ),

    GoRoute(
      name: 'dacalibrare',
      path: '/materialidacalibrare',
      builder: (context, state) {
        return MaterialiDaCalibrareScreen();
      },
    ),
    GoRoute(
      name: 'scadenza',
      path: '/scadenza',
      builder: (context, state) {
        return MaterialiInScadenzaScreen();
      },
    ),
    GoRoute(
      name: 'materialiultimacalibrazione',
      path: '/materialiultimacalibrazione',
      builder: (context, state) {
        return MaterialiConUltimaCalibrazioneScreen();
      },
    ),

    GoRoute(
      name: 'materialiRaggruppati',
      path: '/materialiRaggruppati',
      builder: (context, state) => MaterialiRaggruppatiPerEnteScreen(
        enteId: state.uri.queryParameters['enteId'],
      ),
    ),
    GoRoute(
      path: '/contratti',
      name: 'contratti',
      builder: (context, state) => const ContrattiScreen(),
      routes: [
        GoRoute(
          path: ':id',
          name: 'contrattoDettaglio',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return ContrattoDettaglioScreen(id: id);
          },
          routes: [
            GoRoute(
              path: 'riepilogo',
              name: 'riepilogoCostiContratto',
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return RiepilogoCostiContrattoScreen(idContratto: id);
              },
            ),
          ],
        ),
      ],
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
