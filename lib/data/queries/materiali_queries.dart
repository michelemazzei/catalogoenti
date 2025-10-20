import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'materiali_queries.g.dart';

@DriftAccessor(tables: [Materiali])
class MaterialiQueries extends DatabaseAccessor<AppDatabase>
    with _$MaterialiQueriesMixin {
  MaterialiQueries(super.db);

  Future<List<Materiale>> getAllMateriali() {
    return (select(
      materiali,
    )..orderBy([(m) => OrderingTerm(expression: m.partNumber)])).get();
  }

  Future<List<Materiale>> getMaterialiByReparto(int repartoId) =>
      (select(materiali)..where((m) => m.repartoId.equals(repartoId))).get();

  Future<Materiale?> getMaterialeById(int id) =>
      (select(materiali)..where((m) => m.id.equals(id))).getSingleOrNull();

  Future<List<Materiale>> getMaterialiByRepartiIds(List<int> repartoIds) {
    if (repartoIds.isEmpty) return Future.value([]);

    return (select(
      materiali,
    )..where((m) => m.repartoId.isIn(repartoIds))).get();
  }
}
