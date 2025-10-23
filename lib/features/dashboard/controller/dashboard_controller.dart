import 'package:catalogoenti/features/calibrazione/providers/calibrazione_providers.dart';
import 'package:catalogoenti/providers/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dashboard_stats.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  Future<DashboardStats> build() async {
    return await _loadStats();
  }

  Future<void> loadStats() async {
    if (state is AsyncLoading) return;

    state = const AsyncLoading();
    try {
      final stats = await _loadStats();
      state = AsyncData(stats);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<DashboardStats> _loadStats() async {
    // Leggi il database manager
    final dao = await ref.watch(daoSessionCQRSProvider.future);

    final enti = await dao.entiQueries.getAllEnti();
    final materiali = await dao.materialiQueries.getAllMateriali();
    final contratti = await dao.contrattiQueries.getAllContratti();

    final daCalibrare = await ref.watch(materialiDaCalibrareProvider.future);
    final inScadenza = await ref.watch(materialiInScadenzaProvider.future);

    return DashboardStats(
      contrattiCount: contratti.length,
      entiCount: enti.length,
      materialiCount: materiali.length,
      daCalibrareCount: daCalibrare.length,
      inScadenzaCount: inScadenza.length,
    );
  }
}
