import 'package:catalogoenti/features/contratti/providers/contratti_providers.dart';
import 'package:catalogoenti/shared/domain/pezzo_riparato.dart';
import 'package:catalogoenti/shared/utils.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class ContrattoDettaglioScreen extends HookConsumerWidget {
  final int id;
  const ContrattoDettaglioScreen({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dettaglioAsync = ref.watch(contrattoDettaglioProvider(id));
    final euroFormat = NumberFormat.currency(locale: 'it_IT', symbol: '€');

    final sortColumnIndex = useState<int?>(null);
    final sortAscending = useState(true);
    final rowsPerPage = useState(PaginatedDataTable.defaultRowsPerPage);

    return Scaffold(
      appBar: AppBar(title: Text('Contratto #$id')),
      body: dettaglioAsync.when(
        data: (dettaglio) {
          final sortedPezzi = [...dettaglio.pezziRiparati];
          if (sortColumnIndex.value != null) {
            sortedPezzi.sort((a, b) {
              int result;
              switch (sortColumnIndex.value) {
                case 0:
                  result = a.partNumber.compareTo(b.partNumber);
                  break;
                case 1:
                  result = a.denominazione.compareTo(b.denominazione);
                  break;
                case 2:
                  result = (a.nsn ?? '').compareTo(b.nsn ?? '');
                  break;
                case 3:
                  result = (a.costo ?? 0).compareTo(b.costo ?? 0);
                  break;
                default:
                  result = 0;
              }
              return sortAscending.value ? result : -result;
            });
          }

          final dataSource = _PezziRiparatiDataSource(
            sortedPezzi,
            euroFormat,
            onSelect: (int materialeId) {
              context.pushNamed(
                'materialeDettaglio',
                pathParameters: {'id': materialeId.toString()},
              );
            },
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
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
                    const SizedBox(height: 8),
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
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: PaginatedDataTable2(
                  sortColumnIndex: sortColumnIndex.value,
                  sortAscending: sortAscending.value,
                  rowsPerPage: rowsPerPage.value,
                  onRowsPerPageChanged: (value) {
                    if (value != null) rowsPerPage.value = value;
                  },
                  columns: [
                    DataColumn(
                      label: const Text('Ente'),
                      onSort: (i, asc) {
                        sortColumnIndex.value = i;
                        sortAscending.value = asc;
                      },
                    ),
                    DataColumn(
                      label: const Text('P/N'),
                      onSort: (i, asc) {
                        sortColumnIndex.value = i;
                        sortAscending.value = asc;
                      },
                    ),
                    DataColumn(
                      label: const Text('Denominazione'),
                      onSort: (i, asc) {
                        sortColumnIndex.value = i;
                        sortAscending.value = asc;
                      },
                    ),
                    DataColumn(
                      label: const Text('NSN'),
                      onSort: (i, asc) {
                        sortColumnIndex.value = i;
                        sortAscending.value = asc;
                      },
                    ),
                    DataColumn(
                      label: const Text('Costo'),
                      numeric: true,
                      onSort: (i, asc) {
                        sortColumnIndex.value = i;
                        sortAscending.value = asc;
                      },
                    ),
                  ],
                  source: dataSource,
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 600,
                  showCheckboxColumn: false,
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
      ),
    );
  }
}

class _PezziRiparatiDataSource extends DataTableSource {
  final List<PezzoRiparato> pezzi;
  final NumberFormat euroFormat;
  final Function(int) onSelect;

  _PezziRiparatiDataSource(
    this.pezzi,
    this.euroFormat, {
    required this.onSelect,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= pezzi.length) return null;
    final p = pezzi[index];
    return DataRow.byIndex(
      onSelectChanged: (_) => onSelect(p.id),
      index: index,
      cells: [
        DataCell(Text(p.nomeEnte)),
        DataCell(Text(p.partNumber)),
        DataCell(Text(p.denominazione)),
        DataCell(Text(p.nsn ?? '')),
        DataCell(Text(p.costo != null ? euroFormat.format(p.costo) : '—')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => pezzi.length;
  @override
  int get selectedRowCount => 0;
}
