import 'package:catalogoenti/features/contratti/providers/contratti_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RiepilogoCostiContrattoWidget extends ConsumerWidget {
  final int idContratto;

  const RiepilogoCostiContrattoWidget({required this.idContratto, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riepilogoAsync = ref.watch(
      riepilogoCostiContrattoProvider(idContratto),
    );
    final formatter = NumberFormat.currency(locale: 'it_IT', symbol: '€');

    return riepilogoAsync.when(
      data: (riepilogo) {
        final totaleGenerale = riepilogo.fold<double>(
          0.0,
          (sum, e) => sum + e.totale,
        );

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Ente')),
              DataColumn(label: Text('Interventi')),
              DataColumn(label: Text('Pezzi')),
              DataColumn(label: Text('Prezzo medio')),
              DataColumn(label: Text('Totale')),
            ],
            rows: [
              ...riepilogo.map(
                (e) => DataRow(
                  cells: [
                    DataCell(Text(e.ente)),
                    DataCell(Text(e.numeroInterventi.toString())),
                    DataCell(Text(e.totalePezzi.toString())),
                    DataCell(Text(formatter.format(e.prezzoUnitarioMedio))),
                    DataCell(Text(formatter.format(e.totale))),
                  ],
                ),
              ),
              DataRow(
                color: WidgetStateProperty.all(Colors.grey.shade200),
                cells: [
                  const DataCell(
                    Text(
                      'Totale',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const DataCell(Text('')),
                  const DataCell(Text('')),
                  const DataCell(Text('')),
                  DataCell(
                    Text(
                      formatter.format(totaleGenerale),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Errore: $e'),
    );
  }
}
