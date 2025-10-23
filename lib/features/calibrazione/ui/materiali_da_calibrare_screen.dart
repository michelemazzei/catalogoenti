import 'package:catalogoenti/features/calibrazione/providers/calibrazione_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MaterialiDaCalibrareScreen extends ConsumerWidget {
  const MaterialiDaCalibrareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialiAsync = ref.watch(materialiDaCalibrareProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Materiali da calibrare')),
      body: materialiAsync.when(
        data: (materiali) {
          if (materiali.isEmpty) {
            return const Center(
              child: Text('Nessun materiale da calibrare 🎉'),
            );
          }

          return ListView.separated(
            itemCount: materiali.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final materiale = materiali[index];

              return ListTile(
                leading: const Icon(Icons.warning_amber, color: Colors.red),
                title: Text(materiale.partNumber),
                subtitle: Text(materiale.denominazione),
                trailing: const Text('⚠️ Da calibrare'),
                onTap: () {
                  // Puoi navigare alla scheda del materiale o aprire un dettaglio
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Errore: $err')),
      ),
    );
  }
}
