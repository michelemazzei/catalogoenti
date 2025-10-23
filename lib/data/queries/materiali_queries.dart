import 'package:catalogoenti/shared/domain/materiale_con_ultimo_intervento.dart';
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

  Future<MaterialeConUltimoIntervento?> materialeConUltimoIntervento(
    int id,
  ) async {
    final result = await db
        .customSelect(
          '''
    SELECT m.*, MAX(i.data_intervento) AS ultimo_intervento
    FROM materiali m
    LEFT JOIN interventi i ON m.id = i.materiale_id
    WHERE m.id = ?
    GROUP BY m.id
    ''',
          variables: [Variable.withInt(id)],
          readsFrom: {db.materiali, db.interventi},
        )
        .getSingleOrNull();

    if (result == null) return null;

    final materiale = db.materiali.map(result.data);
    final ultimoIntervento = result.read<int>('ultimo_intervento');

    return MaterialeConUltimoIntervento(
      materiale: materiale,
      ultimoIntervento: DateTime.fromMillisecondsSinceEpoch(
        ultimoIntervento * 1000,
      ),
    );
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
