import 'package:catalogoenti/shared/domain/materiale_con_ultimo_intervento.dart';
import 'package:catalogoenti/shared/utils.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'calibrazioni_queries.g.dart';

@DriftAccessor(tables: [Materiali, Reparti, Interventi, Enti])
class CalibrazioniQueries extends DatabaseAccessor<AppDatabase>
    with _$CalibrazioniQueriesMixin {
  CalibrazioniQueries(super.db);

  Future<List<MaterialeConUltimoIntervento>> getMaterialiInScadenza({
    int days = 365,
  }) async {
    final oggi = DateTime.now();
    final inizioFinestra = oggi.subtract(Duration(days: days + 30)); // ~13 mesi
    final fineFinestra = oggi.subtract(Duration(days: days - 30)); // ~11 mesi

    final result = await customSelect(
      '''
    SELECT m.*, e.nome as ENTE_NOME, e.id as ENTE_ID, MAX(i.data_intervento) AS ultimo_intervento
    FROM materiali m
    LEFT JOIN interventi i ON m.id = i.materiale_id
    LEFT JOIN reparti r ON r.id = m.reparto_id
    LEFT JOIN enti e ON r.ente_id = e.id
    GROUP BY m.id
    HAVING ultimo_intervento BETWEEN ? AND ?
    ''',
      variables: [
        Variable.withDateTime(inizioFinestra),
        Variable.withDateTime(fineFinestra),
      ],
      readsFrom: {materiali, interventi, reparti, enti},
    ).get();

    return result.map((row) {
      final materiale = materiali.map(row.data);
      final rawTimestamp = row.data['ultimo_intervento'] as int?;
      final ultimaData = rawTimestamp != null ? toDate(rawTimestamp) : null;

      return MaterialeConUltimoIntervento(
        nomeEnte: row.data['ENTE_NOME'],
        enteId: row.data['ENTE_ID'] as int?,
        materiale: materiale,
        ultimoIntervento: ultimaData,
      );
    }).toList();
  }

  Future<List<MaterialeConUltimoIntervento>>
  getMaterialiConUltimoIntervento() async {
    final result = await customSelect(
      '''
    SELECT m.*,e.id as ENTE_ID, e.nome as NOME_ENTE, MAX(i.data_intervento) AS ultimo_intervento
    FROM materiali m
    LEFT JOIN interventi i ON m.id = i.materiale_id
    LEFT JOIN reparti r ON r.id = m.reparto_id
    LEFT JOIN enti e ON r.ente_id = e.id
    GROUP BY m.id
    ORDER BY m.part_number
    ''',
      readsFrom: {materiali, interventi, reparti, enti},
    ).get();

    return result.map((row) {
      final materiale = materiali.map(row.data);
      final rawTimestamp = row.data['ultimo_intervento'] as int?;
      final ultimaData = rawTimestamp != null ? toDate(rawTimestamp) : null;
      return MaterialeConUltimoIntervento(
        nomeEnte: row.data['NOME_ENTE'],
        materiale: materiale,
        enteId: row.data['ENTE_ID'] as int?,
        ultimoIntervento: ultimaData,
      );
    }).toList();
  }

  Future<List<MaterialeConUltimoIntervento>> getMaterialiDaCalibrare() async {
    final oggi = DateTime.now();
    final materiali = await getMaterialiConUltimoIntervento();

    final daCalibrare = <MaterialeConUltimoIntervento>[];

    for (final row in materiali) {
      final materiale = row.materiale;
      final ultimaData = row.ultimoIntervento;
      final toAdd = await _isDaCalibrare(materiale, ultimaData, oggi);

      if (toAdd) {
        daCalibrare.add(row);
        continue;
      }
    }

    return daCalibrare;
  }

  Future<bool> _isDaCalibrare(
    Materiale materiale,
    DateTime? ultimaData,
    DateTime oggi,
  ) async {
    final numeroRichiesto = materiale.numeroCalibrazioni ?? 1;

    if (ultimaData == null) return true;

    final mesiTrascorsi = oggi.difference(ultimaData).inDays ~/ 30;
    if (mesiTrascorsi > 12) return true;

    final calibrazioniRecenti =
        await (db.select(db.interventi)..where(
              (i) =>
                  i.materialeId.equals(materiale.id) &
                  i.dataIntervento.isBiggerOrEqualValue(
                    oggi.subtract(Duration(days: 365)),
                  ),
            ))
            .get();

    if (calibrazioniRecenti.length < numeroRichiesto) {
      return true;
    }
    return false;
  }
}
