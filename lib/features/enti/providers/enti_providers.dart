import 'package:catalogoenti/data/database/app_database.dart';
import 'package:catalogoenti/features/materiali/providers/materiali_providers.dart';
import 'package:catalogoenti/providers/database_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'enti_providers.g.dart';

@riverpod
Future<List<Ente>> entiList(Ref ref) async {
  final dao = await ref.watch(daoSessionCQRSProvider.future);
  return (await dao.entiQueries.getAllEnti())
    ..sort((a, b) => a.nome.compareTo(b.nome));
}

@riverpod
Future<Ente> enteById(Ref ref, int id) async {
  final dao = await ref.watch(daoSessionCQRSProvider.future);
  return dao.entiQueries.getEnteById(id);
}

@riverpod
Future<List<Reparto>> repartiPerEnte(Ref ref, int enteId) async {
  final dao = await ref.watch(daoSessionCQRSProvider.future);
  return dao.repartiQueries.getRepartiByEnteId(enteId);
}

@riverpod
Future<List<Materiale>> materialiPerEnte(Ref ref, int enteId) async {
  final dao = await ref.watch(daoSessionCQRSProvider.future);

  final reparti = await dao.repartiQueries.getRepartiByEnteId(enteId);
  final repartoIds = reparti.map((r) => r.id).toList();

  return ref.watch(materialiPerRepartiProvider(repartoIds).future);
}

@riverpod
Future<(Ente, List<Materiale>)> enteEMateriali(Ref ref, int enteId) async {
  final ente = await ref.watch(enteByIdProvider(enteId).future);
  final materiali = await ref.watch(materialiPerEnteProvider(enteId).future);
  return (ente, materiali);
}
