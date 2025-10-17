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
        bottomNavigationBar: Padding(
          padding: EdgeInsetsGeometry.only(bottom: 10),
          child: SizedBox(
            height: 32,
            child: Center(
              child: Text(
                '📁 ${stats.materialiCount} materiali — ${stats.entiCount} enti',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
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
