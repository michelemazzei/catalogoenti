import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'intervento_contratti_commands.g.dart';

@DriftAccessor(tables: [InterventoContratti])
class InterventoContrattiCommands extends DatabaseAccessor<AppDatabase>
    with _$InterventoContrattiCommandsMixin {
  InterventoContrattiCommands(super.db);

  Future<void> linkInterventoAContratto(
    int interventoId,
    int contrattoId,
  ) async {
    await into(interventoContratti).insert(
      InterventoContrattiCompanion.insert(
        interventoId: interventoId,
        contrattoId: contrattoId,
      ),
    );
  }
}
