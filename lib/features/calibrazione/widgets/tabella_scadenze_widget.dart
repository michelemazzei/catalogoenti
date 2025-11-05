import 'dart:async';
import 'package:catalogoenti/shared/domain/materiale_con_ultimo_intervento.dart';
import 'package:catalogoenti/shared/utils.dart';
import 'package:catalogoenti/shared/widgets/text_search_bar.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class TabellaScadenzeWidget extends HookWidget {
  final List<MaterialeConUltimoIntervento> materiali;
  final String? enteId;

  const TabellaScadenzeWidget({
    super.key,
    required this.materiali,
    this.enteId,
  });

  @override
  Widget build(BuildContext context) {
    final rawQuery = useState('');
    final debouncedQuery = useState('');
    final sortColumnIndex = useState<int?>(null);
    final sortAscending = useState(true);

    useEffect(() {
      final timer = Timer(const Duration(milliseconds: 300), () {
        debouncedQuery.value = rawQuery.value;
      });
      return timer.cancel;
    }, [rawQuery.value]);

    final materialiFiltrati = materiali.where((m) {
      final query = debouncedQuery.value.toLowerCase();
      final matchTesto =
          m.materiale.partNumber.toLowerCase().contains(query) ||
          m.materiale.denominazione.toLowerCase().contains(query) ||
          (m.materiale.note ?? '').toLowerCase().contains(query);

      final matchEnte = enteId == null || m.enteId.toString() == enteId;

      return matchTesto && matchEnte;
    }).toList();

    final sortedMateriali = [...materialiFiltrati];
    if (sortColumnIndex.value != null) {
      sortedMateriali.sort((a, b) {
        int result;
        switch (sortColumnIndex.value) {
          case 0:
            result = (a.nomeEnte ?? '').compareTo(b.nomeEnte ?? '');
            break;
          case 1:
            result = a.materiale.partNumber.compareTo(b.materiale.partNumber);
            break;
          case 2:
            result = a.materiale.denominazione.compareTo(
              b.materiale.denominazione,
            );
            break;
          case 3:
            final aDate = a.ultimoIntervento ?? DateTime(1900);
            final bDate = b.ultimoIntervento ?? DateTime(1900);
            result = aDate.compareTo(bDate);
            break;
          default:
            result = 0;
        }
        return sortAscending.value ? result : -result;
      });
    }

    final dataSource = _ScadenzeDataSource(sortedMateriali, context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSearchBar(
          label: 'Cerca materiale da calibrare...',
          onChanged: (value) => rawQuery.value = value,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: PaginatedDataTable2(
            showCheckboxColumn: false,
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
                label: const Text('Ultimo Intervento'),
                onSort: (i, asc) {
                  sortColumnIndex.value = i;
                  sortAscending.value = asc;
                },
              ),
            ],
            source: dataSource,
            rowsPerPage: 10,
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: 600,
          ),
        ),
      ],
    );
  }
}

class _ScadenzeDataSource extends DataTableSource {
  final List<MaterialeConUltimoIntervento> materiali;
  final BuildContext context;

  _ScadenzeDataSource(this.materiali, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= materiali.length) return null;
    final m = materiali[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(m.nomeEnte ?? '')),
        DataCell(Text(m.materiale.partNumber)),
        DataCell(Text(m.materiale.denominazione)),
        DataCell(Text(formatDate(m.ultimoIntervento))),
      ],
      onSelectChanged: (_) {
        context.pushNamed(
          'materialeDettaglio',
          pathParameters: {'id': m.materiale.id.toString()},
        );
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => materiali.length;
  @override
  int get selectedRowCount => 0;
}
