import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:catalogoenti/data/database/database_manager.dart';
import 'package:catalogoenti/tool/import_interventi.dart';
import 'package:catalogoenti/tool/import_materiali.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      log('🚀 Avvio importazione da Excel (inMemory)', name: 'IMPORT_MAIN');
      final container = ProviderContainer();
      final manager = container.read(databaseManagerProvider.notifier);
      await manager.inMemory();

      final db = manager.current;
      if (db == null) {
        log('💥 Errore: database non disponibile', name: 'IMPORT_MAIN');
        return;
      }

      const materialiExcel = 'data/materiali_import.xlsx';
      const interventiExcel = 'data/interventi_import.xlsx';

      // Import materiali
      await importMaterialiDaExcel(db, materialiExcel);

      // Import interventi con contratto GARA2022
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
      log('🧹 Database in memoria chiuso', name: 'IMPORT_MAIN');
      exit(0);
    },
    (e, st) {
      log('💥 Errore non gestito: $e', name: 'IMPORT_MAIN');
      log('📍 StackTrace: $st', name: 'IMPORT_MAIN');
      exit(1);
    },
  );
}
