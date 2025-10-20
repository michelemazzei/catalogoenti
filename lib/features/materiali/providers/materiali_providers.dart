import 'package:catalogoenti/data/database/app_database.dart';
import 'package:catalogoenti/features/materiali/domain/ente_con_reparti.dart';
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

@riverpod
Future<Materiale?> materialeById(Ref ref, int id) async {
  final dao = await ref.watch(daoSessionCQRSProvider.future);
  return dao.materialiQueries.getMaterialeById(id);
}

@riverpod
Future<List<EnteConReparti>> entiPerMateriale(Ref ref, int materialeId) async {
  final dao = await ref.watch(daoSessionCQRSProvider.future);

  // Trova tutti i reparti che possiedono il materiale
  final reparti = await dao.materialiRepartiQueries.getRepartiPerMateriale(
    materialeId,
  );

  // Raggruppa per ente
  final entiMap = <int, EnteConReparti>{};

  for (final reparto in reparti) {
    final enteId = reparto.enteId;
    final ente = await dao.entiQueries.getEnteById(enteId);

    entiMap.putIfAbsent(enteId, () => EnteConReparti(ente: ente, reparti: []));
    entiMap[enteId]!.reparti.add(reparto);
  }

  return entiMap.values.toList();
}
