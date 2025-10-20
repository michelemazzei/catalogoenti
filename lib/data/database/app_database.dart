import 'dart:developer';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DataClassName('Ente')
class Enti extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get zona => text().nullable()(); // es. "Nord", "Sud"
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
  IntColumn get periodicita => integer().withDefault(const Constant(12))();
  IntColumn get numeroCalibrazioni =>
      integer().nullable()(); // derivato, opzionale
}

@DataClassName('MaterialeReparto')
class MaterialiReparti extends Table {
  IntColumn get materialeId => integer().references(Materiali, #id)();
  IntColumn get repartoId => integer().references(Reparti, #id)();
  IntColumn get quantita => integer().withDefault(const Constant(1))();
  DateTimeColumn get ultimaManutenzione => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {materialeId, repartoId};
}

@DataClassName('Intervento')
class Interventi extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get materialeId => integer().references(Materiali, #id)();
  RealColumn get prezzoUnitario => real()();
  DateTimeColumn get dataIntervento => dateTime()();
  TextColumn get note => text().nullable()();
}

@DataClassName('Contratto')
class Contratti extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get codice => text()(); // es. "GARA2022"
  DateTimeColumn get dataInizio => dateTime()();
  DateTimeColumn get dataFine => dateTime().nullable()();
  RealColumn get tassoRivalutazione => real().nullable()(); // es. 1.01
  RealColumn get indiceDAAA => real().nullable()(); // es. 1.0769
}

@DataClassName('InterventoContratto')
class InterventoContratti extends Table {
  IntColumn get interventoId => integer().references(Interventi, #id)();
  IntColumn get contrattoId => integer().references(Contratti, #id)();
}

@DriftDatabase(
  tables: [
    Enti,
    Reparti,
    Materiali,
    Interventi,
    MaterialiReparti,
    Contratti,
    InterventoContratti,
  ],
)
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
