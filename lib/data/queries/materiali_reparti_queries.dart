import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'materiali_reparti_queries.g.dart';

@DriftAccessor(tables: [MaterialiReparti, Reparti, Enti])
class MaterialiRepartiQueries extends DatabaseAccessor<AppDatabase>
    with _$MaterialiRepartiQueriesMixin {
  MaterialiRepartiQueries(super.db);

  Future<List<Ente>> getEntiChePossiedonoMateriale(int materialeId) async {
    final query = select(enti).join([
      innerJoin(reparti, reparti.id.equalsExp(enti.id)),
      innerJoin(
        materialiReparti,
        materialiReparti.repartoId.equalsExp(reparti.id) &
            materialiReparti.materialeId.equals(materialeId),
      ),
    ]);

    final rows = await query.get();
    return rows.map((row) => row.readTable(enti)).toList();
  }

  Future<List<Reparto>> getRepartiPerMateriale(int materialeId) async {
    final query = select(reparti).join([
      innerJoin(
        materialiReparti,
        materialiReparti.repartoId.equalsExp(reparti.id) &
            materialiReparti.materialeId.equals(materialeId),
      ),
    ]);

    final rows = await query.get();
    return rows.map((row) => row.readTable(reparti)).toList();
  }
}
