import 'dart:developer';

import 'package:catalogoenti/providers/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dashboard_stats.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  Future<DashboardStats> build() async {
    try {
      final daoSession = await ref.watch(daoSessionCQRSProvider.future);

      final enti = await daoSession.entiQueries.getAllEnti();
      final materiali = await daoSession.materialiQueries.getAllMateriali();

      int daCalibrare = 0;
      int inScadenza = 0;
      final now = DateTime.now();
      final limite = now.add(const Duration(days: 365));

      for (final materiale in materiali) {
        final interventi = await daoSession.interventiQueries
            .getInterventiByMateriale(materiale.id);

        final ultima = interventi
            .map((i) => i.dataIntervento)
            .fold<DateTime?>(
              null,
              (prev, curr) => prev == null || curr.isAfter(prev) ? curr : prev,
            );

        if (ultima == null) {
          daCalibrare++;
          continue;
        }

        final prossima = ultima.add(Duration(days: materiale.periodicita * 30));
        if (prossima.isBefore(now)) {
          daCalibrare++;
        } else if (prossima.isBefore(limite)) {
          inScadenza++;
        }
      }

      return DashboardStats(
        entiCount: enti.length,
        materialiCount: materiali.length,
        inScadenzaCount: inScadenza,
        daCalibrareCount: daCalibrare,
      );
    } catch (e, st) {
      log('💥 Errore in DashboardController: $e', name: 'DashboardController');
      log('📍 StackTrace: $st', name: 'DashboardController');
      rethrow;
    }
  }
}
