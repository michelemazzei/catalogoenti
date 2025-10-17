import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'materiali_queries.g.dart';

@DriftAccessor(tables: [Materiali])
class MaterialiQueries extends DatabaseAccessor<AppDatabase>
    with _$MaterialiQueriesMixin {
  MaterialiQueries(super.db);

  Future<List<Materiale>> getAllMateriali() => select(materiali).get();

  Future<List<Materiale>> getMaterialiByReparto(int repartoId) =>
      (select(materiali)..where((m) => m.repartoId.equals(repartoId))).get();

  Future<List<Materiale>> getMaterialiByRepartiIds(List<int> repartoIds) {
    if (repartoIds.isEmpty) return Future.value([]);

    return (select(
      materiali,
    )..where((m) => m.repartoId.isIn(repartoIds))).get();
  }
}
