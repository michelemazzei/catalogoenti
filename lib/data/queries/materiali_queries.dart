import 'package:catalogoenti/shared/domain/materiale_con_ultimo_intervento.dart';
import 'package:catalogoenti/shared/domain/materiale_per_ente.dart';
import 'package:catalogoenti/shared/utils.dart';
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
      ultimoIntervento: toDate(ultimoIntervento),
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

  Future<Map<String, List<MaterialePerEnte>>>
  getMaterialiRaggruppatiPerEnte() async {
    final rows = await db
        .customSelect(
          '''
    SELECT 
      m.id as ID , 
      e.nome AS ente,
      r.nome AS reparto,
      r.localita AS localita,
      m.part_number AS part_number,
      m.denominazione AS denominazione,
      m.nsn AS nsn,
      m.note AS note
    FROM interventi i
    JOIN materiali m ON i.materiale_id = m.id
    JOIN reparti r ON m.reparto_id = r.id
    JOIN enti e ON r.ente_id = e.id
    JOIN intervento_contratti ic ON ic.intervento_id = i.id
    GROUP BY e.nome, r.nome, r.localita, m.part_number, m.denominazione, m.nsn, m.note
    ORDER BY e.nome, r.nome, m.part_number
    ''',
          readsFrom: {
            db.interventi,
            db.materiali,
            db.reparti,
            db.enti,
            db.interventoContratti,
          },
        )
        .get();

    final Map<String, List<MaterialePerEnte>> raggruppati = {};

    for (final row in rows) {
      final materiale = MaterialePerEnte(
        id: row.read<int>('ID'),
        ente: row.read<String>('ente'),
        reparto: row.read<String>('reparto'),
        localita: row.read<String>('localita'),
        partNumber: row.read<String>('part_number'),
        denominazione: row.read<String>('denominazione'),
        nsn: row.read<String?>('nsn') ?? '',
        note: row.read<String?>('note') ?? '',
      );

      raggruppati.putIfAbsent(materiale.ente, () => []).add(materiale);
    }

    return raggruppati;
  }
}
