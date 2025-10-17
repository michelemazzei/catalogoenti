import 'package:catalogoenti/providers/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dashboard_stats.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  Future<DashboardStats> build() async {
    final dao = await ref.watch(appDaoProvider.future);

    final enti = await dao.getAllEnti();
    final materiali = await dao.getAllMateriali();

    int daCalibrare = 0;

    for (final materiale in materiali) {
      final interventi = await dao.getInterventiByMateriale(materiale.id);

      final ultima = interventi.map((i) => i.dataIntervento).fold<DateTime?>(
        null,
        (prev, curr) {
          if (prev == null || curr.isAfter(prev)) return curr;
          return prev;
        },
      );

      if (ultima == null) {
        daCalibrare++;
        continue;
      }

      final prossima = ultima.add(Duration(days: materiale.periodicita * 30));
      if (prossima.isBefore(DateTime.now())) {
        daCalibrare++;
      }
    }

    int inScadenza = 0;
    final now = DateTime.now();
    final limite = now.add(const Duration(days: 365));

    for (final materiale in materiali) {
      final interventi = await dao.getInterventiByMateriale(materiale.id);
      final ultima = interventi
          .map((i) => i.dataIntervento)
          .fold<DateTime?>(
            null,
            (prev, curr) => prev == null || curr.isAfter(prev) ? curr : prev,
          );

      if (ultima != null) {
        final prossima = ultima.add(Duration(days: materiale.periodicita * 30));
        if (prossima.isAfter(now) && prossima.isBefore(limite)) {
          inScadenza++;
        }
      }
    }

    return DashboardStats(
      entiCount: enti.length,
      materialiCount: materiali.length,
      inScadenzaCount: inScadenza,

      daCalibrareCount: daCalibrare,
    );
  }
}
