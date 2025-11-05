import 'package:catalogoenti/shared/domain/materiale_per_ente.dart';
import 'package:flutter/material.dart';

class MaterialiDataSource extends DataTableSource {
  List<MaterialePerEnte> materiali;

  final void Function(MaterialePerEnte) onRowTap;

  MaterialiDataSource(this.materiali, {required this.onRowTap});

  void sort(int columnIndex, bool ascending) {
    Comparator<MaterialePerEnte> comparator;
    switch (columnIndex) {
      case 0:
        comparator = (a, b) => a.ente.compareTo(b.ente);
        break;
      case 1:
        comparator = (a, b) => a.reparto.compareTo(b.reparto);
        break;
      case 2:
        comparator = (a, b) => a.localita.compareTo(b.localita);
        break;
      case 3:
        comparator = (a, b) => a.partNumber.compareTo(b.partNumber);
        break;
      case 4:
        comparator = (a, b) => a.denominazione.compareTo(b.denominazione);
        break;
      case 5:
        comparator = (a, b) => a.nsn.compareTo(b.nsn);
        break;
      default:
        comparator = (a, b) => 0;
    }

    materiali.sort(ascending ? comparator : (a, b) => comparator(b, a));
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    final m = materiali[index];
    final isEven = index % 2 == 0;

    return DataRow.byIndex(
      onSelectChanged: (_) => onRowTap(m),

      index: index,
      color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        return isEven ? Colors.white : Colors.grey.shade100;
      }),
      cells: [
        DataCell(Text(m.ente)),
        DataCell(Text(m.reparto)),
        DataCell(Text(m.localita)),
        DataCell(Text(m.partNumber)),
        DataCell(Text(m.denominazione)),
        DataCell(Text(m.nsn)),
        DataCell(Text(m.note)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => materiali.length;
  @override
  int get selectedRowCount => 0;
}
