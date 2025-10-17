import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'package:drift/drift.dart';
import 'package:excel/excel.dart';
import 'package:catalogoenti/data/database/app_database.dart';
import 'package:catalogoenti/data/database/import_helpers.dart';
import 'package:catalogoenti/data/database/database_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      log('🚀 Avvio importazione da Excel (inMemory)');
      final container = ProviderContainer();
      final manager = container.read(databaseManagerProvider.notifier);
      await manager.inMemory();

      final file = File('data/catalogo_import.xlsx');
      if (!file.existsSync()) {
        log('❌ File Excel non trovato: ${file.path}');
        return;
      }

      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);
      final sheet = excel[excel.tables.keys.first];

      final db = manager.current;

      if (db == null) {
        log('💥 Errore: database non disponibile');
        return;
      }

      int materialiImportati = 0;

      for (final row in sheet.rows.skip(1)) {
        final enteNome = row[0]?.value?.toString().trim();
        final repartoNome = row[1]?.value?.toString().trim();
        final localitaNome = row[2]?.value?.toString().trim();
        final partNumber = row[3]?.value?.toString().trim();
        final denominazione = row[4]?.value?.toString().trim();
        final ndc = row[5]?.value?.toString().trim();
        final note = row[6]?.value?.toString().trim();

        if ([
          enteNome,
          repartoNome,
          localitaNome,
          partNumber,
          denominazione,
        ].any((v) => v == null || v.isEmpty)) {
          log('⚠️ Riga incompleta, ignorata');
          continue;
        }

        final enteId = await getOrInsertEnte(db, enteNome!);
        final repartoId = await getOrInsertReparto(
          db,
          repartoNome!,
          enteId,
          localitaNome!,
        );

        await db
            .into(db.materiali)
            .insert(
              MaterialiCompanion.insert(
                partNumber: partNumber!,
                denominazione: denominazione!,
                nsn: ndc ?? '',
                note: note?.isNotEmpty == true
                    ? Value(note)
                    : const Value.absent(),
                repartoId: repartoId,
              ),
            );

        materialiImportati++;
        log('✅ Inserito materiale: $partNumber — $denominazione');
      }

      log('📈 Totale materiali importati: $materialiImportati');
      await manager.dispose();
      container.dispose();
      log('🧹 Database in memoria chiuso');
      exit(0);
    },
    (e, st) {
      log('💥 Errore non gestito: $e', name: 'IMPORTER');
      log('📍 StackTrace: $st', name: 'IMPORTER');
      exit(1); // errore
    },
  );
}
