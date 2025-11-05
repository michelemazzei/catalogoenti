import 'package:catalogoenti/features/contratti/providers/contratti_providers.dart';
import 'package:catalogoenti/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ContrattoDettaglioScreen extends ConsumerWidget {
  final int id;
  const ContrattoDettaglioScreen({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dettaglioAsync = ref.watch(contrattoDettaglioProvider(id));

    final euroFormat = NumberFormat.currency(locale: 'it_IT', symbol: '€');

    return Scaffold(
      appBar: AppBar(title: Text('Contratto #$id')),
      body: dettaglioAsync.when(
        data: (dettaglio) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Codice: ${dettaglio.contratto.codice}'),
            Text('Da: ${formatDate(dettaglio.contratto.dataInizio)}'),
            Text('A: ${formatDate(dettaglio.contratto.dataFine)}'),
            Text('Indice DAAA: ${dettaglio.contratto.indiceDAAA ?? 0}'),
            Text(
              'Tasso di rivalutazione: ${dettaglio.contratto.tassoRivalutazione ?? 0}',
            ),
            Text('Totale: ${euroFormat.format(dettaglio.costoTotale)}'),
            ElevatedButton.icon(
              icon: const Icon(Icons.bar_chart),
              label: const Text('Riepilogo Costi'),
              onPressed: () {
                context.pushNamed(
                  'riepilogoCostiContratto',
                  pathParameters: {'id': id.toString()},
                );
              },
            ),

            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: dettaglio.pezziRiparati.length,
                itemBuilder: (context, index) {
                  final pezzo = dettaglio.pezziRiparati[index];
                  return ListTile(
                    title: Text('P/N:\t${pezzo.partNumber}'),
                    subtitle: Text(
                      '${pezzo.denominazione} \nNSN:\t${pezzo.nsn ?? ''}',
                    ),
                    trailing: Text(
                      'Costo: €${pezzo.costo?.toStringAsFixed(2) ?? '—'}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
      ),
    );
  }
}
