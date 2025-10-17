import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'reparti_commands.g.dart';

@DriftAccessor(tables: [Reparti])
class RepartiCommands extends DatabaseAccessor<AppDatabase>
    with _$RepartiCommandsMixin {
  RepartiCommands(super.db);

  Future<int> insertReparto(Reparto reparto) => into(reparti).insert(reparto);
}
