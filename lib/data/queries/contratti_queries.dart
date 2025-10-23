import 'package:catalogoenti/shared/domain/pezzo_riparato.dart';
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
}
