import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:catalogoenti/data/database/database_manager.dart';
import 'package:catalogoenti/tool/import_interventi.dart';
import 'package:catalogoenti/tool/import_materiali.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main(List<String> args) async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      log('🟢 Script avviato', name: 'IMPORT_MAIN');

      final container = ProviderContainer();
      final manager = container.read(databaseManagerProvider.notifier);
      final dbPath = Platform.environment['DB_PATH'];
      log('📦 DB_PATH = ${dbPath ?? 'null'}', name: 'IMPORT_MAIN');

      // ✅ Fallback: se non c'è argomento, usa inMemory
      if (dbPath?.isEmpty ?? true) {
        log('🚀 Avvio importazione da Excel (inMemory)', name: 'IMPORT_MAIN');
        await manager.inMemory();
      } else {
        log(
          '🚀 Avvio importazione da Excel (nel file: ${dbPath!})',
          name: 'IMPORT_MAIN',
        );
        final file = File(dbPath);
        log('📍 Prima di loadFromFile', name: 'IMPORT_MAIN');

        await file.create(recursive: true);
        log(
          '🚀 Avvio importazione da Excel su file: $dbPath',
          name: 'IMPORT_MAIN',
        );
        await manager.loadOrCreate(file);
        log('✅ Dopo loadFromFile', name: 'IMPORT_MAIN');
      }

      final db = manager.current;

      const materialiExcel = 'data/materiali_import.xlsx';
      const interventiExcel = 'data/interventi_import.xlsx';

      await importMaterialiDaExcel(db, materialiExcel);

      await importInterventiDaExcel(
        db,
        interventiExcel,
        codiceContratto: 'GARA2022',
        tassoRivalutazione: 1.01,
        indiceDAAA: 1.0769,
        dataInizioContratto: DateTime(2022, 1, 1),
      );

      await manager.dispose();
      container.dispose();
      log('✅ Importazione completata e database chiuso', name: 'IMPORT_MAIN');
      exit(0);
    },
    (e, st) {
      log('💥 Errore non gestito: $e', name: 'IMPORT_MAIN');
      log('📍 StackTrace: $st', name: 'IMPORT_MAIN');
      exit(1);
    },
  );
}
