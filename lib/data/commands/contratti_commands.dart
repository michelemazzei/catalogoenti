import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'contratti_commands.g.dart';

@DriftAccessor(tables: [Contratti])
class ContrattiCommands extends DatabaseAccessor<AppDatabase>
    with _$ContrattiCommandsMixin {
  ContrattiCommands(super.db);

  Future<int> insertContratto(Contratto contratto) =>
      into(contratti).insert(contratto);
}
