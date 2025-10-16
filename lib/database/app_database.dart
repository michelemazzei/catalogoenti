import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DataClassName('Ente')
class Enti extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get zona => text()(); // "Nord" o "Sud"
}

@DataClassName('Reparto')
class Reparti extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get enteId => integer().references(Enti, #id)();
  TextColumn get nome => text()();
  TextColumn get localita => text()();
}

@DataClassName('Materiale')
class Materiali extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get repartoId => integer().references(Reparti, #id)();
  TextColumn get partNumber => text()();
  TextColumn get denominazione => text()();
  TextColumn get nsn => text()();
  TextColumn get note => text().nullable()();
  IntColumn get quantita => integer().withDefault(const Constant(1))();
  IntColumn get periodicita =>
      integer().withDefault(const Constant(12))(); // mesi
  IntColumn get numeroCalibrazioni => integer().nullable()();
}

@DataClassName('Intervento')
class Interventi extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get materialeId => integer().references(Materiali, #id)();
  RealColumn get prezzoUnitario => real()();
  DateTimeColumn get dataIntervento => dateTime()();

  RealColumn get prezzoUnitarioGara => real().nullable()();
  RealColumn get prezzoRivalutato2022 => real().nullable()();
  RealColumn get prezzoAnnuale => real().nullable()();
  RealColumn get prezzoAnnualeRivalutato2022 => real().nullable()();
}

@DriftDatabase(tables: [Enti, Reparti, Materiali, Interventi])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'catalogo_enti.sqlite'));
    return NativeDatabase(file);
  });
}
