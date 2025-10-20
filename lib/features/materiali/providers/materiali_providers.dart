import 'package:catalogoenti/data/database/app_database.dart';
import 'package:catalogoenti/providers/database_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'materiali_providers.g.dart';

@riverpod
Future<List<Materiale>> tuttiIMateriali(Ref ref) async {
  final dao = await ref.watch(daoSessionCQRSProvider.future);
  return dao.materialiQueries.getAllMateriali();
}

@riverpod
Future<List<Materiale>> materialiPerReparti(
  Ref ref,
  List<int> repartoIds,
) async {
  final dao = await ref.watch(daoSessionCQRSProvider.future);

  if (repartoIds.isEmpty) return [];

  return dao.materialiQueries.getMaterialiByRepartiIds(repartoIds);
}
