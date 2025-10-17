import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'contratti_queries.g.dart';

@DriftAccessor(tables: [Contratti])
class ContrattiQueries extends DatabaseAccessor<AppDatabase>
    with _$ContrattiQueriesMixin {
  ContrattiQueries(super.db);

  Future<List<Contratto>> getAllContratti() => select(contratti).get();
}
