import 'dart:developer';

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
  TextColumn get zona => text().nullable()(); // "Nord" o "Sud"
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
  AppDatabase._internal(super.e);

  AppDatabase.custom(File file)
    : super(NativeDatabase(file, logStatements: true));
  factory AppDatabase.inMemory() {
    return AppDatabase._internal(NativeDatabase.memory());
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();

    if (!await dbFolder.exists()) {
      await dbFolder.create(recursive: true);
      log('📁 Cartella DB creata: ${dbFolder.path}', name: 'OPEN_CONNECTION');
    } else {
      log(
        '📁 Cartella DB esistente: ${dbFolder.path}',
        name: 'OPEN_CONNECTION',
      );
    }

    final file = File(p.join(dbFolder.path, 'catalogo_enti.sqlite'));
    try {
      if (!await file.exists()) {
        await file.create();
        log(
          '📄 File DB non trovato, creato nuovo: ${file.path}',
          name: 'OPEN_CONNECTION',
        );
      } else {
        log('📄 File DB esistente: ${file.path}', name: 'OPEN_CONNECTION');
      }
    } catch (exception) {
      log(
        'Errore nell\'apertura del file: $exception',
        name: 'OPEN_CONNECTION',
      );
      throw Exception('Errore nella creazione del file del database.');
    }

    return NativeDatabase(file);
  });
}
