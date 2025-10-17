import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'materiali_commands.g.dart';

@DriftAccessor(tables: [Materiali])
class MaterialiCommands extends DatabaseAccessor<AppDatabase>
    with _$MaterialiCommandsMixin {
  MaterialiCommands(super.db);

  Future<int> insertMateriale(Materiale materiale) =>
      into(materiali).insert(materiale);
}
