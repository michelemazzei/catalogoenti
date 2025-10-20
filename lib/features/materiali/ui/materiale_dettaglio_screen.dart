import 'package:catalogoenti/features/materiali/providers/materiali_providers.dart';
import 'package:catalogoenti/features/place_holder/ui/placeholder_screen.dart';
import 'package:catalogoenti/features/materiali/widgets/enti_possessori_wdget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MaterialeDettaglioScreen extends ConsumerWidget {
  final int? id;

  const MaterialeDettaglioScreen({super.key, this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id == null) {
      return const PlaceholderScreen(
        message: 'Part number non valido.',
        title: 'Materiale',
        submessage: 'Torna alla home page e ripeti la ricerca',
        icon: Icons.hourglass_empty,
      );
    }

    final materialeAsync = ref.watch(materialeByIdProvider(id!));

    return Scaffold(
      appBar: AppBar(title: const Text('Dettaglio Materiale')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: materialeAsync.when(
          data: (m) {
            if (m == null) {
              return const PlaceholderScreen(
                message: 'Part number non valido.',
                title: 'Materiale',
                submessage: 'Torna alla home page e ripeti la ricerca',
                icon: Icons.hourglass_empty,
              );
            }

            return ListView(
              children: [
                Text(
                  'Part Number: ${m.partNumber}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text('NSN: ${m.nsn}'),
                const SizedBox(height: 8),
                Text('Denominazione: ${m.denominazione}'),
                const SizedBox(height: 8),
                Text('Note: ${m.note ?? ''}'),
                const SizedBox(height: 8),
                Text('Quantità: ${m.quantita}'),
                const SizedBox(height: 8),
                Text('Periodicitià: ${m.periodicita}'),
                const SizedBox(height: 8),
                Text(
                  'Numero di calibrazioni ogni anno: ${m.numeroCalibrazioni ?? ''}',
                ),
                const Divider(height: 32),
                EntiPossessoriWidget(materialeId: m.id),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Errore: $e')),
        ),
      ),
    );
  }
}
