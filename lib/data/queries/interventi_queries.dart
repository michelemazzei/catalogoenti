import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'interventi_queries.g.dart';

@DriftAccessor(tables: [Interventi])
class InterventiQueries extends DatabaseAccessor<AppDatabase>
    with _$InterventiQueriesMixin {
  InterventiQueries(super.db);

  Future<List<Intervento>> getInterventiByMateriale(int materialeId) => (select(
    interventi,
  )..where((i) => i.materialeId.equals(materialeId))).get();
}
