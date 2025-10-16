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

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: const Text('Dashboard')),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (stats) => SingleChildScrollView(
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
            ],
          ),
        ),
      ),
    );
  }
}
