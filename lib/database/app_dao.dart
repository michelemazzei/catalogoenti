import 'package:drift/drift.dart';
import 'app_database.dart';

part 'app_dao.g.dart';

@DriftAccessor(tables: [Enti, Reparti, Materiali, Interventi])
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
}
