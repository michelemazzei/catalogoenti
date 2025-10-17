import 'package:catalogoenti/data/database/app_database.dart';
import 'package:catalogoenti/providers/database_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reparti_providers.g.dart';

@riverpod
Future<Reparto> repartoById(Ref ref, int repartoId) async {
  final dao = await ref.watch(daoSessionCQRSProvider.future);
  return dao.repartiQueries.getRepartoById(repartoId);
}
