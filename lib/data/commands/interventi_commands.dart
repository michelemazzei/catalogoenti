import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'interventi_commands.g.dart';

@DriftAccessor(tables: [Interventi])
class InterventiCommands extends DatabaseAccessor<AppDatabase>
    with _$InterventiCommandsMixin {
  InterventiCommands(super.db);

  Future<int> insertIntervento(Intervento intervento) =>
      into(interventi).insert(intervento);
}
