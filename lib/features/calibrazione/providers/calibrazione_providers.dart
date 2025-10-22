import 'package:catalogoenti/data/database/app_database.dart';
import 'package:catalogoenti/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calibrazione_providers.g.dart';

@riverpod
Future<List<Materiale>> materialiDaCalibrare(Ref ref) async {
  final dao = await ref.watch(daoSessionCQRSProvider.future);
  final queries = dao.calibrazioniQueries;
  return queries.getMaterialiDaCalibrare();
}
