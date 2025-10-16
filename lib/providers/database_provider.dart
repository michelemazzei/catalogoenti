import 'package:catalogoenti/database/app_dao.dart';
import 'package:catalogoenti/database/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// lib/providers/database_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase database(Ref ref) => AppDatabase();

@Riverpod(keepAlive: true)
AppDao appDao(Ref ref) => AppDao(ref.watch(databaseProvider));
