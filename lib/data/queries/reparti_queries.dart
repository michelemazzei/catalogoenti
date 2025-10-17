import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'reparti_queries.g.dart';

@DriftAccessor(tables: [Reparti])
class RepartiQueries extends DatabaseAccessor<AppDatabase>
    with _$RepartiQueriesMixin {
  RepartiQueries(super.db);

  Future<List<Reparto>> getRepartiByEnte(int enteId) =>
      (select(reparti)..where((r) => r.enteId.equals(enteId))).get();

  Future<List<Reparto>> getRepartiByEnteId(int enteId) {
    return (select(reparti)..where((r) => r.enteId.equals(enteId))).get();
  }

  Future<Reparto> getRepartoById(int id) {
    return (select(reparti)..where((r) => r.id.equals(id))).getSingle();
  }
}
