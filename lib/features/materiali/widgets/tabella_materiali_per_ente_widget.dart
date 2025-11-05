import 'package:catalogoenti/features/materiali/domain/materiali_data_source.dart';
import 'package:catalogoenti/features/materiali/providers/materiali_providers.dart';
import 'package:catalogoenti/shared/widgets/text_search_bar.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TabellaMaterialiPerEnteWidget extends HookConsumerWidget {
  const TabellaMaterialiPerEnteWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialiAsync = ref.watch(materialiRaggruppatiPerEnteProvider);

    final sortColumnIndex = useState<int?>(null);
    final sortAscending = useState(true);
    final rowsPerPage = useState(PaginatedDataTable.defaultRowsPerPage);
    final searchQuery = useState('');

    return materialiAsync.when(
      data: (raggruppati) {
        final tuttiMateriali = raggruppati.entries.expand((entry) {
          final ente = entry.key;
          return entry.value.map((m) => m.copyWith(ente: ente));
        }).toList();

        // Applica filtro
        final materialiFiltrati = tuttiMateriali.where((m) {
          final query = searchQuery.value.toLowerCase();
          return m.ente.toLowerCase().contains(query) ||
              m.reparto.toLowerCase().contains(query) ||
              m.localita.toLowerCase().contains(query) ||
              m.partNumber.toLowerCase().contains(query) ||
              m.denominazione.toLowerCase().contains(query) ||
              m.nsn.toLowerCase().contains(query) ||
              (m.note).toLowerCase().contains(query);
        }).toList();

        final dataSource = MaterialiDataSource(
          materialiFiltrati,

          onRowTap: (materiale) {
            context.pushNamed(
              'materialeDettaglio',
              pathParameters: {'id': materiale.id.toString()},
            );
          },
        );

        useEffect(() {
          if (sortColumnIndex.value != null) {
            dataSource.sort(sortColumnIndex.value!, sortAscending.value);
          }
          return null;
        }, [sortColumnIndex.value, sortAscending.value]);

        return Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextSearchBar(
              label: 'Cerca materiale...',
              onChanged: (value) => searchQuery.value = value,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: PaginatedDataTable2(
                showCheckboxColumn: false,
                columns: [
                  DataColumn(
                    label: const Text('Ente'),
                    onSort: (i, asc) {
                      sortColumnIndex.value = i;
                      sortAscending.value = asc;
                    },
                  ),
                  DataColumn(
                    label: const Text('Reparto'),
                    onSort: (i, asc) {
                      sortColumnIndex.value = i;
                      sortAscending.value = asc;
                    },
                  ),
                  DataColumn(
                    label: const Text('Località'),
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
                  const DataColumn(label: Text('Note')),
                ],
                source: dataSource,
                rowsPerPage: rowsPerPage.value,
                onRowsPerPageChanged: (value) {
                  if (value != null) rowsPerPage.value = value;
                },
                sortColumnIndex: sortColumnIndex.value,
                sortAscending: sortAscending.value,
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 900,
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Errore: $e')),
    );
  }
}
