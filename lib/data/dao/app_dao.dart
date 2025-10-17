import 'package:drift/drift.dart';

import '../database/app_database.dart';

part 'app_dao.g.dart';

@DriftAccessor(
  tables: [
    Enti,
    Reparti,
    Materiali,
    Interventi,
    Contratti,
    InterventoContratti,
  ],
)
class AppDao extends DatabaseAccessor<AppDatabase> with _$AppDaoMixin {
  AppDao(super.db);

  // ENTI
  Future<List<Ente>> getAllEnti() => select(enti).get();
  Future<int> insertEnte(Ente ente) => into(enti).insert(ente);

  // REPARTI
  Future<List<Reparto>> getRepartiByEnte(int enteId) =>
      (select(reparti)..where((r) => r.enteId.equals(enteId))).get();
  Future<int> insertReparto(Reparto reparto) => into(reparti).insert(reparto);

  // MATERIALI
  Future<List<Materiale>> getAllMateriali() => select(materiali).get();
  Future<List<Materiale>> getMaterialiByReparto(int repartoId) =>
      (select(materiali)..where((m) => m.repartoId.equals(repartoId))).get();
  Future<int> insertMateriale(Materiale materiale) =>
      into(materiali).insert(materiale);

  // INTERVENTI
  Future<List<Intervento>> getInterventiByMateriale(int materialeId) => (select(
    interventi,
  )..where((i) => i.materialeId.equals(materialeId))).get();
  Future<int> insertIntervento(Intervento intervento) =>
      into(interventi).insert(intervento);

  // CONTRATTI
  Future<List<Contratto>> getAllContratti() => select(contratti).get();
  Future<int> insertContratto(Contratto contratto) =>
      into(contratti).insert(contratto);

  // INTERVENTO ↔ CONTRATTO
  Future<void> linkInterventoAContratto(
    int interventoId,
    int contrattoId,
  ) async {
    await into(interventoContratti).insert(
      InterventoContrattiCompanion.insert(
        interventoId: interventoId,
        contrattoId: contrattoId,
      ),
    );
  }

  Future<Map<String, double>> getPrezziRivalutatiPerIntervento(
    int interventoId,
  ) async {
    final intervento = await (select(
      interventi,
    )..where((i) => i.id.equals(interventoId))).getSingleOrNull();
    if (intervento == null) return {};

    final materiale = await (select(
      materiali,
    )..where((m) => m.id.equals(intervento.materialeId))).getSingleOrNull();
    final periodicita = materiale?.periodicita ?? 12;

    final link = await (select(
      interventoContratti,
    )..where((ic) => ic.interventoId.equals(interventoId))).getSingleOrNull();
    if (link == null) {
      return {'prezzoAnnuale': intervento.prezzoUnitario * periodicita};
    }

    final contratto = await (select(
      contratti,
    )..where((c) => c.id.equals(link.contrattoId))).getSingleOrNull();
    if (contratto == null) {
      return {'prezzoAnnuale': intervento.prezzoUnitario * periodicita};
    }

    final prezzoGara =
        intervento.prezzoUnitario * (contratto.tassoRivalutazione ?? 1.0);
    final prezzoRivalutato = prezzoGara * (contratto.indiceDAAA ?? 1.0);
    final prezzoAnnualeRivalutato = prezzoRivalutato * periodicita;

    return {
      'prezzoUnitarioGara': prezzoGara,
      'prezzoRivalutato2022': prezzoRivalutato,
      'prezzoAnnualeRivalutato2022': prezzoAnnualeRivalutato,
    };
  }
}
