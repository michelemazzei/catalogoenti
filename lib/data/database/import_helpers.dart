import 'package:catalogoenti/data/database/app_database.dart';
import 'package:drift/drift.dart';

Future<int> getOrInsertEnte(AppDatabase db, String nome) async {
  final existing = await (db.select(
    db.enti,
  )..where((e) => e.nome.equals(nome))).getSingleOrNull();
  if (existing != null) return existing.id;
  return await db.into(db.enti).insert(EntiCompanion.insert(nome: nome));
}

Future<int> getOrInsertReparto(
  AppDatabase db,
  String nome,
  int enteId,
  String localita,
) async {
  final existing =
      await (db.select(db.reparti)..where(
            (r) =>
                Expression.and([r.nome.equals(nome), r.enteId.equals(enteId)]),
          ))
          .getSingleOrNull();
  if (existing != null) return existing.id;
  return await db
      .into(db.reparti)
      .insert(
        RepartiCompanion.insert(nome: nome, localita: localita, enteId: enteId),
      );
}

Future<int> getOrInsertMateriale(AppDatabase db, MaterialiCompanion m) async {
  final existing =
      await (db.select(db.materiali)
            ..where((mat) => mat.partNumber.equals(m.partNumber.value)))
          .getSingleOrNull();
  if (existing != null) return existing.id;
  return await db.into(db.materiali).insert(m);
}

Future<int> getOrInsertContratto(
  AppDatabase db,
  String codice,
  double? tassoRivalutazione,
  double? indiceDAAA,
  DateTime dataInizio, {
  DateTime? dataFine,
}) async {
  final existing = await (db.select(
    db.contratti,
  )..where((c) => c.codice.equals(codice))).getSingleOrNull();

  if (existing != null) {
    return existing.id;
  }

  final contrattoId = await db
      .into(db.contratti)
      .insert(
        ContrattiCompanion.insert(
          codice: codice,
          dataInizio: dataInizio,
          dataFine: Value(dataFine),
          tassoRivalutazione: Value(tassoRivalutazione ?? 1.0),
          indiceDAAA: Value(indiceDAAA ?? 1.0),
        ),
      );

  return contrattoId;
}

Future<void> getOrUpdateMaterialeReparto({
  required AppDatabase db,
  required int materialeId,
  required int repartoId,
  required int quantita,
  required DateTime ultimaManutenzione,
}) async {
  final existing =
      await (db.select(db.materialiReparti)..where(
            (tbl) =>
                tbl.materialeId.equals(materialeId) &
                tbl.repartoId.equals(repartoId),
          ))
          .getSingleOrNull();

  if (existing == null) {
    await db
        .into(db.materialiReparti)
        .insert(
          MaterialiRepartiCompanion.insert(
            materialeId: materialeId,
            repartoId: repartoId,
            quantita: Value(quantita),
            ultimaManutenzione: Value(ultimaManutenzione),
          ),
        );
  } else {
    await (db.update(db.materialiReparti)..where(
          (tbl) =>
              tbl.materialeId.equals(materialeId) &
              tbl.repartoId.equals(repartoId),
        ))
        .write(
          MaterialiRepartiCompanion(
            quantita: Value(quantita),
            ultimaManutenzione: Value(ultimaManutenzione),
          ),
        );
  }
}
