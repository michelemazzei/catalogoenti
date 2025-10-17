import 'package:drift/drift.dart';
import '../database/app_database.dart';

part 'enti_queries.g.dart';

@DriftAccessor(tables: [Enti])
class EntiQueries extends DatabaseAccessor<AppDatabase>
    with _$EntiQueriesMixin {
  EntiQueries(super.db);

  Future<List<Ente>> getAllEnti() => select(enti).get();

  Future<Ente> getEnteById(int id) {
    return (select(enti)..where((tbl) => tbl.id.equals(id))).getSingle();
  }
}
