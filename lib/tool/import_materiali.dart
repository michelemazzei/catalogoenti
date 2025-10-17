library;

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:catalogoenti/data/database/app_database.dart';
import 'package:catalogoenti/data/database/import_helpers.dart';
import 'package:drift/drift.dart';
import 'package:excel/excel.dart';

Future<void> importMaterialiDaExcel(AppDatabase db, String filePath) async {
  final file = File(filePath);
  if (!file.existsSync()) {
    log('❌ File Excel non trovato: $filePath', name: 'IMPORT_MATERIALI');
    return;
  }

  final bytes = file.readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);
  final sheet = excel[excel.tables.keys.first];

  int materialiImportati = 0;
  int righeIgnorate = 0;

  for (final row in sheet.rows.skip(1)) {
    final enteNome = row[0]?.value?.toString().trim();
    final repartoNome = row[1]?.value?.toString().trim();
    final localitaNome = row[2]?.value?.toString().trim();
    final partNumber = row[3]?.value?.toString().trim();
    final denominazione = row[4]?.value?.toString().trim();
    final nsn = row[5]?.value?.toString().trim();
    final note = row[6]?.value?.toString().trim();

    if ([
      enteNome,
      repartoNome,
      localitaNome,
      partNumber,
      denominazione,
    ].any((v) => v == null || v.isEmpty)) {
      righeIgnorate++;
      continue;
    }

    final enteId = await getOrInsertEnte(db, enteNome!);
    final repartoId = await getOrInsertReparto(
      db,
      repartoNome!,
      enteId,
      localitaNome!,
    );

    final materialeId = await getOrInsertMateriale(
      db,
      MaterialiCompanion.insert(
        partNumber: partNumber!,
        denominazione: denominazione!,
        nsn: nsn ?? '',
        note: note?.isNotEmpty == true ? Value(note) : const Value.absent(),
        repartoId: repartoId,
      ),
    );

    materialiImportati++;
    log(
      '✅ Materiale registrato: $materialeId $partNumber — $denominazione',
      name: 'IMPORT_MATERIALI',
    );
  }

  log(
    '📈 Totale materiali importati: $materialiImportati',
    name: 'IMPORT_MATERIALI',
  );
  log('📉 Righe ignorate: $righeIgnorate', name: 'IMPORT_MATERIALI');
}
