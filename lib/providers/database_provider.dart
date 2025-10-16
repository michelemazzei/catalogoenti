import 'package:catalogoenti/data/dao/app_dao.dart';
import 'package:catalogoenti/data/database/database_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// lib/providers/database_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

@Riverpod()
Future<AppDao> appDao(Ref ref) async {
  final db = await ref.watch(databaseManagerProvider.future);
  return AppDao(db!);
}
