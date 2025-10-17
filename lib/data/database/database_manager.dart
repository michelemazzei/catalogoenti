import 'dart:developer';
import 'dart:io';

import 'package:catalogoenti/data/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'database_manager.g.dart';

@riverpod
class DatabaseManager extends _$DatabaseManager {
  AppDatabase? _db;
  String? _path;

  String? get path => _path;
  bool get isReady => _db != null;
  bool get isInMemory => _path == 'In Memory';

  AppDatabase get current {
    if (_db == null) {
      throw StateError('Database non inizializzato');
    }
    return _db!;
  }

  bool _disposed = false;

  @override
  Future<AppDatabase?> build() async {
    ref.onDispose(() async => await dispose());

    final lastPath = await loadLastUsedPath();
    if (lastPath != null && File(lastPath).existsSync()) {
      return await loadOrCreate(File(lastPath));
    }
    return await inMemory(); // fallback
  }

  Future<AppDatabase> inMemory() async {
    dispose();
    _path = 'In Memory';
    _db = AppDatabase.inMemory();
    state = AsyncValue.data(_db);
    _disposed = false;

    return _db!;
  }

  Future<AppDatabase> loadOrCreate(File file) async {
    dispose();
    if (!await file.exists()) {
      await file.create(recursive: true);
      log('📄 Creato nuovo database: ${file.path}', name: 'DatabaseManager');
    }
    return (await _loadFromFile(file))!;
  }

  Future<AppDatabase?> _loadFromFile(File file) async {
    dispose();

    if (!(file.path.endsWith('.sqlite') || file.path.endsWith('.db'))) {
      log('⚠️ File non valido: ${file.path}', name: 'DatabaseManager');
      _path = 'File non valido';
      state = AsyncValue.error('Estensione non valida', StackTrace.current);
      return null;
    }

    try {
      log('📦 Caricamento database da: ${file.path}', name: 'DatabaseManager');
      _db = AppDatabase.custom(file);
      _path = file.path;
      state = AsyncValue.data(_db);
      _disposed = false;
      await saveLastUsedPath(file.path);
      return _db;
    } catch (e, st) {
      log('💥 Errore nel caricamento: $e', name: 'DatabaseManager');
      _path = 'Errore nel file';
      state = AsyncValue.error(e, st);
    }
    return null;
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await _db?.close();
    log('🧹 Database chiuso, path : $path', name: 'DatabaseManager');
  }

  Future<void> saveLastUsedPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_db_path', path);
  }

  Future<String?> loadLastUsedPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_db_path');
  }
}
