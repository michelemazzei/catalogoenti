import 'dart:developer';
import 'dart:io';

import 'package:catalogoenti/data/database/app_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as p;
part 'database_manager.g.dart';

@riverpod
class DatabaseManager extends _$DatabaseManager {
  AppDatabase? _db;
  String? _path;

  @override
  Future<AppDatabase?> build() async {
    ref.onDispose(() async {
      await dispose();
      log('🧹 Database chiuso', name: 'DatabaseManager');
    });

    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'catalogo_enti.sqlite'));

    if (!await file.exists()) {
      await file.create(recursive: true);
      log(
        '📄 Creato database di default: ${file.path}',
        name: 'DatabaseManager',
      );
    } else {
      log(
        '📄 Database di default esistente: ${file.path}',
        name: 'DatabaseManager',
      );
    }

    await _db?.close();
    _db = AppDatabase.custom(file);
    _path = file.path;
    return _db;
  }

  Future<void> inMemory() async {
    dispose();
    _path = 'In Memory';
    _db = AppDatabase.inMemory();
    state = AsyncValue.data(_db);
  }

  Future<void> loadFromFile(File file) async {
    dispose();
    if (!await file.exists()) {
      log('❌ Il file non esiste: ${file.path}', name: 'DatabaseManager');
      _path = 'File inesistente';
      state = AsyncValue.error(
        'File non trovato: ${file.path}',
        StackTrace.current,
      );
      return;
    }

    if (!file.path.endsWith('.sqlite')) {
      log('⚠️ File non valido: ${file.path}', name: 'DatabaseManager');
      _path = 'File non valido';
      state = AsyncValue.error('Estensione non valida', StackTrace.current);
      return;
    }

    try {
      log('📦 Caricamento database da: ${file.path}', name: 'DatabaseManager');
      _db = AppDatabase.custom(file);
      _path = file.path;
      state = AsyncValue.data(_db);
    } catch (e, st) {
      log('💥 Errore nel caricamento: $e', name: 'DatabaseManager');
      _path = 'Errore nel file';
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> dispose() async {
    await _db?.close();
    log('🧹 Database chiuso', name: 'DatabaseManager');
  }

  AppDatabase? get current => _db;
  String? get path => _path;
}
