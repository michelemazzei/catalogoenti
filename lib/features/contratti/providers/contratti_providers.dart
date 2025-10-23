import 'package:catalogoenti/data/database/app_database.dart';
import 'package:catalogoenti/features/contratti/domain/contratto_dettaglio.dart';
import 'package:catalogoenti/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contratti_providers.g.dart';

@riverpod
Future<List<Contratto>> tuttiIContratti(Ref ref) async {
  final dao = await ref.watch(daoSessionCQRSProvider.future);
  return dao.contrattiQueries.getAllContratti();
}

@riverpod
Future<ContrattoDettaglio> contrattoDettaglio(Ref ref, int id) async {
  final dao = await ref.watch(daoSessionCQRSProvider.future);

  final contratto = await dao.contrattiQueries.getContrattoById(id);
  final pezziRiparati = await dao.contrattiQueries.getPezziRiparatiPerContratto(
    id,
  );

  final costoTotale = pezziRiparati.fold<double>(
    0.0,
    (sum, pezzo) => sum + (pezzo.costo ?? 0) * pezzo.periodicita,
  );

  return ContrattoDettaglio(
    contratto: contratto!,
    pezziRiparati: pezziRiparati,
    costoTotale: costoTotale,
  );
}
