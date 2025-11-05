import 'package:catalogoenti/shared/domain/pezzo_riparato.dart';
import 'package:catalogoenti/shared/domain/riepilogo_costi_contratto.dart';
import 'package:catalogoenti/shared/utils.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'contratti_queries.g.dart';

@DriftAccessor(tables: [Contratti])
class ContrattiQueries extends DatabaseAccessor<AppDatabase>
    with _$ContrattiQueriesMixin {
  ContrattiQueries(super.db);

  Future<List<Contratto>> getAllContratti() => select(contratti).get();

  Future<Contratto?> getContrattoById(int id) {
    return (select(contratti)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  Future<List<PezzoRiparato>> getPezziRiparatiPerContratto(int contrattoId) {
    return db
        .customSelect(
          '''
    SELECT m.id AS materiale_id,
           m.denominazione as denominazione,
           m.part_number as part_number,  
           m.nsn as nsn,  
           m.periodicita as periodicita,
           m.quantita as quantita,
           i.prezzo_unitario AS costo , 
           i.data_intervento as data
    FROM  interventi i, materiali m, intervento_contratti ic
    WHERE 
          i.materiale_id = m.id
    AND
          ic.contratto_id = ? 
    AND
          ic.intervento_id = i.id 
    ORDER BY  part_number

    ''',
          variables: [Variable.withInt(contrattoId)],
          readsFrom: {db.interventi, db.materiali},
        )
        .map((row) {
          return PezzoRiparato(
            denominazione: row.read<String?>('denominazione') ?? '',
            id: row.read<int>('materiale_id'),
            periodicita: row.read<int>('periodicita'),
            quantita: row.read<int>('quantita'),
            partNumber: row.read<String>('part_number'),
            nsn: row.read<String?>('nsn') ?? '',
            data: toDate(row.read<int?>('data')),
            costo: row.read<double?>('costo'),
          );
        })
        .get();
  }

  Future<List<RiepilogoCostiContratto>> getRiepilogoCostiPerContratto(
    int contrattoId,
  ) {
    return db
        .customSelect(
          '''
    SELECT 
      e.nome AS ente,
      COUNT(i.id) AS numero_interventi,
      SUM(m.quantita) AS totale_pezzi,
      AVG(i.prezzo_unitario) AS prezzo_unitario_medio,
      SUM(i.prezzo_unitario * m.quantita * COALESCE(m.numero_calibrazioni, 1)) AS totale
    FROM interventi i
    JOIN materiali m ON i.materiale_id = m.id
    JOIN reparti r ON m.reparto_id = r.id
    JOIN enti e ON r.ente_id = e.id
    JOIN intervento_contratti ic ON ic.intervento_id = i.id
    WHERE ic.contratto_id = ?
    GROUP BY e.nome
    ORDER BY totale DESC
    ''',
          variables: [Variable.withInt(contrattoId)],
          readsFrom: {
            db.interventi,
            db.materiali,
            db.reparti,
            db.enti,
            db.interventoContratti,
          },
        )
        .map((row) {
          return RiepilogoCostiContratto(
            ente: row.read<String>('ente'),
            numeroInterventi: row.read<int>('numero_interventi'),
            totalePezzi: row.read<int>('totale_pezzi'),
            prezzoUnitarioMedio: row.read<double>('prezzo_unitario_medio'),
            totale: row.read<double>('totale'),
          );
        })
        .get();
  }
}
