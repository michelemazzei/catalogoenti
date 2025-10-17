library;

import 'dart:io';
import 'dart:developer';
import 'package:drift/drift.dart';
import 'package:excel/excel.dart';
import 'package:catalogoenti/data/database/app_database.dart';
import 'package:catalogoenti/data/database/import_helpers.dart';

Future<void> importInterventiDaExcel(
  AppDatabase db,
  String filePath, {
  required String codiceContratto,
  required double tassoRivalutazione,
  required double indiceDAAA,
  required DateTime dataInizioContratto,
}) async {
  final file = File(filePath);
  if (!file.existsSync()) {
    log('❌ File Excel non trovato: $filePath', name: 'IMPORT_INTERVENTI');
    return;
  }

  final bytes = file.readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);
  final sheet = excel[excel.tables.keys.first];

  final contrattoId = await getOrInsertContratto(
    db,
    codiceContratto,
    tassoRivalutazione,
    indiceDAAA,
    dataInizioContratto,
  );

  int interventiImportati = 0;
  int righeIgnorate = 0;

  for (final row in sheet.rows.skip(1)) {
    final partNumber = row[3]?.value?.toString().trim();
    final prezzoUnitarioStr = row[8]?.value?.toString();
    final dataInterventoStr = row[13]?.value?.toString();
    final note = row[14]?.value?.toString().trim();

    if (partNumber == null ||
        partNumber.isEmpty ||
        prezzoUnitarioStr == null ||
        dataInterventoStr == null) {
      righeIgnorate++;
      continue;
    }

    final materiale = await (db.select(
      db.materiali,
    )..where((m) => m.partNumber.equals(partNumber))).getSingleOrNull();
    if (materiale == null) {
      righeIgnorate++;
      continue;
    }

    final prezzoUnitario = _parseEuro(prezzoUnitarioStr);
    final dataIntervento = _parseDate(dataInterventoStr);
    if (prezzoUnitario == null || dataIntervento == null) {
      righeIgnorate++;
      continue;
    }

    final interventoId = await db
        .into(db.interventi)
        .insert(
          InterventiCompanion.insert(
            materialeId: materiale.id,
            prezzoUnitario: prezzoUnitario,
            dataIntervento: dataIntervento,
            note: note?.isNotEmpty == true ? Value(note) : const Value.absent(),
          ),
        );

    await db
        .into(db.interventoContratti)
        .insert(
          InterventoContrattiCompanion.insert(
            interventoId: interventoId,
            contrattoId: contrattoId,
          ),
        );

    interventiImportati++;
    log(
      '✅ Intervento registrato per $partNumber il $dataIntervento',
      name: 'IMPORT_INTERVENTI',
    );
  }

  log(
    '📈 Totale interventi importati: $interventiImportati',
    name: 'IMPORT_INTERVENTI',
  );
  log('📉 Righe ignorate: $righeIgnorate', name: 'IMPORT_INTERVENTI');
}

double? _parseEuro(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  final cleaned = value.replaceAll('€', '').replaceAll(',', '.').trim();
  return double.tryParse(cleaned);
}

DateTime? _parseDate(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  try {
    final parts = value.split('/');
    if (parts.length == 3) {
      return DateTime.parse('${parts[2]}-${parts[1]}-${parts[0]}');
    }
    return DateTime.tryParse(value);
  } catch (_) {
    return null;
  }
}
