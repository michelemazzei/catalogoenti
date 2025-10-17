import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/dtos/materiale_con_contratti.dart';

part 'aggregati_queries.g.dart';

@DriftAccessor(tables: [Materiali, Interventi, Contratti, InterventoContratti])
class AggregatiQueries extends DatabaseAccessor<AppDatabase>
    with _$AggregatiQueriesMixin {
  AggregatiQueries(super.db);

  Future<double> getCostoTotalePerPartNumber(
    String partNumber, {
    int? contrattoId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final materiale = await (select(
      materiali,
    )..where((m) => m.partNumber.equals(partNumber))).getSingleOrNull();
    if (materiale == null) return 0.0;

    List<Intervento> interventiFiltrati;

    if (contrattoId != null) {
      final links = await (select(
        interventoContratti,
      )..where((ic) => ic.contrattoId.equals(contrattoId))).get();
      final ids = links.map((l) => l.interventoId).toSet();

      interventiFiltrati =
          await (select(interventi)..where(
                (i) =>
                    i.materialeId.equals(materiale.id) &
                    i.id.isIn(ids.toList()),
              ))
              .get();
    } else {
      interventiFiltrati = await (select(
        interventi,
      )..where((i) => i.materialeId.equals(materiale.id))).get();
    }

    if (startDate != null || endDate != null) {
      interventiFiltrati = interventiFiltrati.where((i) {
        final d = i.dataIntervento;
        final afterStart = startDate == null || !d.isBefore(startDate);
        final beforeEnd = endDate == null || !d.isAfter(endDate);
        return afterStart && beforeEnd;
      }).toList();
    }

    double totale = 0.0;
    for (final i in interventiFiltrati) {
      totale += i.prezzoUnitario * materiale.periodicita;
    }

    return totale;
  }

  Future<double> getAmmontareTotaleContratto(int contrattoId) async {
    final links = await (select(
      interventoContratti,
    )..where((ic) => ic.contrattoId.equals(contrattoId))).get();

    double totale = 0.0;

    for (final link in links) {
      final intervento = await (select(
        interventi,
      )..where((i) => i.id.equals(link.interventoId))).getSingleOrNull();
      if (intervento == null) continue;

      final materiale = await (select(
        materiali,
      )..where((m) => m.id.equals(intervento.materialeId))).getSingleOrNull();
      if (materiale == null) continue;

      final contratto = await (select(
        contratti,
      )..where((c) => c.id.equals(contrattoId))).getSingleOrNull();
      if (contratto == null) continue;

      final prezzoGara =
          intervento.prezzoUnitario * (contratto.tassoRivalutazione ?? 1.0);
      final prezzoRivalutato = prezzoGara * (contratto.indiceDAAA ?? 1.0);
      final prezzoAnnuale = prezzoRivalutato * materiale.periodicita;

      totale += prezzoAnnuale;
    }

    return totale;
  }

  Future<List<MaterialeConContratti>>
  getMaterialiRiparatiConContrattiNelPeriodo(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final interventiFiltrato =
        await (select(interventi)..where(
              (i) =>
                  i.dataIntervento.isBiggerOrEqualValue(startDate) &
                  i.dataIntervento.isSmallerOrEqualValue(endDate),
            ))
            .get();

    final Map<int, List<int>> materialeToInterventi = {};
    for (final i in interventiFiltrato) {
      materialeToInterventi.putIfAbsent(i.materialeId, () => []).add(i.id);
    }

    final results = <MaterialeConContratti>[];

    for (final entry in materialeToInterventi.entries) {
      final materiale = await (select(
        materiali,
      )..where((m) => m.id.equals(entry.key))).getSingle();

      final links = await (select(
        interventoContratti,
      )..where((ic) => ic.interventoId.isIn(entry.value))).get();
      final contrattoIds = links.map((l) => l.contrattoId).toSet();

      final contrattiAssociati = await (select(
        contratti,
      )..where((c) => c.id.isIn(contrattoIds.toList()))).get();

      results.add(MaterialeConContratti(materiale, contrattiAssociati));
    }

    return results;
  }
}
