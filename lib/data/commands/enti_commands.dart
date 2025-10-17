import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'enti_commands.g.dart';

@DriftAccessor(tables: [Enti])
class EntiCommands extends DatabaseAccessor<AppDatabase>
    with _$EntiCommandsMixin {
  EntiCommands(super.db);

  Future<int> insertEnte(Ente ente) => into(enti).insert(ente);
  Future<void> updateEnte(Ente ente) async {
    update(enti)
      ..where((tbl) => tbl.id.equals(ente.id))
      ..write(EntiCompanion(nome: Value(ente.nome), zona: Value(ente.zona)));
  }
}
