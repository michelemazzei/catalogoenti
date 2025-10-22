import 'package:catalogoenti/shared/domain/materiale_con_ultimo_intervento.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'calibrazioni_queries.g.dart';

@DriftAccessor(tables: [Materiali, Reparti, Interventi, Enti])
class CalibrazioniQueries extends DatabaseAccessor<AppDatabase>
    with _$CalibrazioniQueriesMixin {
  CalibrazioniQueries(super.db);

  Future<List<MaterialeConUltimoIntervento>>
  getMaterialiConUltimoIntervento() async {
    final result = await customSelect(
      '''
    SELECT m.*, MAX(i.data_intervento) AS ultimo_intervento
    FROM materiali m
    LEFT JOIN interventi i ON m.id = i.materiale_id
    GROUP BY m.id
    ''',
      readsFrom: {materiali, interventi},
    ).get();

    return result.map((row) {
      final materiale = Materiale.fromJson(row.data);
      final ultimaData = row.data['ultimo_intervento'] as DateTime?;
      return MaterialeConUltimoIntervento(materiale, ultimaData);
    }).toList();
  }

  Future<List<Materiale>> getMaterialiDaCalibrare() async {
    final oggi = DateTime.now();
    final materiali = await getMaterialiConUltimoIntervento();

    final daCalibrare = <Materiale>[];

    for (final row in materiali) {
      final materiale = row.materiale;
      final ultimaData = row.ultimaIntervento;
      final toAdd = await _isDaCalibrare(materiale, ultimaData, oggi);

      if (toAdd) {
        daCalibrare.add(materiale);
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
