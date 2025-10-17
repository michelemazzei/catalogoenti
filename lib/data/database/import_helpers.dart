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
