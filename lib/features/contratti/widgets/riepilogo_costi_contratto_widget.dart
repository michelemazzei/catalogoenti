import 'package:catalogoenti/features/contratti/providers/contratti_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class RiepilogoCostiContrattoWidget extends HookConsumerWidget {
  final int idContratto;

  const RiepilogoCostiContrattoWidget({required this.idContratto, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riepilogoAsync = ref.watch(
      riepilogoCostiContrattoProvider(idContratto),
    );
    final formatter = NumberFormat.currency(locale: 'it_IT', symbol: '€');

    final sortColumnIndex = useState<int?>(null);
    final sortAscending = useState(true);

    return riepilogoAsync.when(
      data: (riepilogo) {
        final sortedRiepilogo = [...riepilogo];
        if (sortColumnIndex.value != null) {
          sortedRiepilogo.sort((a, b) {
            int result;
            switch (sortColumnIndex.value) {
              case 0:
                result = a.ente.compareTo(b.ente);
                break;
              case 1:
                result = a.numeroInterventi.compareTo(b.numeroInterventi);
                break;
              case 2:
                result = a.totalePezzi.compareTo(b.totalePezzi);
                break;
              case 3:
                result = a.prezzoUnitarioMedio.compareTo(b.prezzoUnitarioMedio);
                break;
              case 4:
                result = a.totale.compareTo(b.totale);
                break;
              default:
                result = 0;
            }
            return sortAscending.value ? result : -result;
          });
        }

        final totaleGenerale = sortedRiepilogo.fold<double>(
          0.0,
          (sum, e) => sum + e.totale,
        );

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortColumnIndex: sortColumnIndex.value,
            sortAscending: sortAscending.value,
            columns: [
              DataColumn(
                label: const Text('Ente'),
                onSort: (i, asc) {
                  sortColumnIndex.value = i;
                  sortAscending.value = asc;
                },
              ),
              DataColumn(
                label: const Text('Interventi'),
                numeric: true,
                onSort: (i, asc) {
                  sortColumnIndex.value = i;
                  sortAscending.value = asc;
                },
              ),
              DataColumn(
                label: const Text('Pezzi'),
                numeric: true,
                onSort: (i, asc) {
                  sortColumnIndex.value = i;
                  sortAscending.value = asc;
                },
              ),
              DataColumn(
                label: const Text('Prezzo medio'),
                numeric: true,
                onSort: (i, asc) {
                  sortColumnIndex.value = i;
                  sortAscending.value = asc;
                },
              ),
              DataColumn(
                label: const Text('Totale'),
                numeric: true,
                onSort: (i, asc) {
                  sortColumnIndex.value = i;
                  sortAscending.value = asc;
                },
              ),
            ],
            rows: [
              ...sortedRiepilogo.map(
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
