import 'package:catalogoenti/providers/database_provider.dart';
import 'package:catalogoenti/shared/domain/materiale_con_ultimo_intervento.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calibrazione_providers.g.dart';

@riverpod
Future<List<MaterialeConUltimoIntervento>> materialiDaCalibrare(Ref ref) async {
  final queries = await ref.watch(calibrazioniQueriesProvider.future);
  return queries.getMaterialiDaCalibrare();
}

@riverpod
Future<List<MaterialeConUltimoIntervento>> materialiInScadenza(Ref ref) async {
  final queries = await ref.watch(calibrazioniQueriesProvider.future);
  return queries.getMaterialiInScadenza();
}

@riverpod
Future<List<MaterialeConUltimoIntervento>> materialiConUltimoIntervento(
  Ref ref,
) async {
  final queries = await ref.watch(calibrazioniQueriesProvider.future);
  return queries.getMaterialiConUltimoIntervento();
}
