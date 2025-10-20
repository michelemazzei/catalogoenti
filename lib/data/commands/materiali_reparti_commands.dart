import 'package:catalogoenti/data/database/app_database.dart';
import 'package:drift/drift.dart';

part 'materiali_reparti_commands.g.dart';

@DriftAccessor(tables: [MaterialiReparti])
class MaterialiRepartiCommands extends DatabaseAccessor<AppDatabase>
    with _$MaterialiRepartiCommandsMixin {
  MaterialiRepartiCommands(super.db);

  Future<void> assegnaMaterialeAReparto({
    required int materialeId,
    required int repartoId,
    required int quantita,
  }) async {
    await into(materialiReparti).insert(
      MaterialiRepartiCompanion.insert(
        materialeId: materialeId,
        repartoId: repartoId,
        quantita: Value(quantita),
      ),
    );
  }
}
