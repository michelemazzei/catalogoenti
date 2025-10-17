import 'package:catalogoenti/data/database/database_manager.dart';
import 'package:catalogoenti/features/dashboard/controller/dashboard_controller.dart';
import 'package:catalogoenti/features/dashboard/ui/app_drawer.dart';
import 'package:catalogoenti/features/dashboard/ui/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardControllerProvider);

    return statsAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text('Dashboard')),
        drawer: AppDrawer(),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        drawer: const AppDrawer(),
        body: Center(child: Text('Errore: $error')),
      ),
      data: (stats) => Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        drawer: const AppDrawer(),
        bottomNavigationBar: Consumer(
          builder: (context, ref, _) {
            final dbManager = ref.watch(databaseManagerProvider.notifier);
            final path = dbManager.path;
            final isMemory = dbManager.isInMemory;

            final status = isMemory
                ? '🧪 Database in memoria (fallback)'
                : '📁 Database: ${path ?? "?"}';

            return Container(
              height: 40,
              color: Theme.of(context).colorScheme.surface,
              alignment: Alignment.center,
              child: Text(
                status,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            );
          },
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DashboardCard(label: 'Enti', count: stats.entiCount),
              DashboardCard(label: 'Materiali', count: stats.materialiCount),
              DashboardCard(
                label: 'Da calibrare',
                count: stats.daCalibrareCount,
              ),
              DashboardCard(
                label: 'In scadenza (un anno)',
                count: stats.inScadenzaCount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
