import 'dart:developer';
import 'dart:io';

import 'package:catalogoenti/data/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_manager.g.dart';

@riverpod
class DatabaseManager extends _$DatabaseManager {
  AppDatabase? _db;
  String? _path;

  String? get path => _path;

  AppDatabase get current {
    if (_db == null) {
      throw StateError('Database non inizializzato');
    }
    return _db!;
  }

  bool _disposed = false;

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await _db?.close();
    log('🧹 Database chiuso, path : $path', name: 'DatabaseManager');
  }

  @override
  Future<AppDatabase?> build() async {
    ref.onDispose(() async {
      await dispose();
      log(
        '🧹 Database chiuso : ${_path ?? "inMemory"}',
        name: 'DatabaseManager',
      );
    });

    return null;
  }

  Future<void> inMemory() async {
    dispose();
    _path = 'In Memory';
    _db = AppDatabase.inMemory();
    state = AsyncValue.data(_db);
  }

  Future<void> loadOrCreate(File file) async {
    dispose();
    if (!await file.exists()) {
      await file.create(recursive: true);
      log('📄 Creato nuovo database: ${file.path}', name: 'DatabaseManager');
    }
    await _loadFromFile(file);
  }

  Future<void> _loadFromFile(File file) async {
    dispose();

    if (!(file.path.endsWith('.sqlite') || file.path.endsWith('.db'))) {
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
}
