import 'package:catalogoenti/data/commands/contratti_commands.dart';
import 'package:catalogoenti/data/commands/enti_commands.dart';
import 'package:catalogoenti/data/commands/interventi_commands.dart';
import 'package:catalogoenti/data/commands/intervento_contratti_commands.dart';
import 'package:catalogoenti/data/commands/materiali_commands.dart';
import 'package:catalogoenti/data/commands/materiali_reparti_commands.dart';
import 'package:catalogoenti/data/commands/reparti_commands.dart';
import 'package:catalogoenti/data/database/database_manager.dart';
import 'package:catalogoenti/data/queries/aggregati_queries.dart';
import 'package:catalogoenti/data/queries/calibrazioni_queries.dart';
import 'package:catalogoenti/data/queries/contratti_queries.dart';
import 'package:catalogoenti/data/queries/enti_queries.dart';
import 'package:catalogoenti/data/queries/interventi_queries.dart';
import 'package:catalogoenti/data/queries/materiali_queries.dart';
import 'package:catalogoenti/data/queries/materiali_reparti_queries.dart';
import 'package:catalogoenti/data/queries/reparti_queries.dart';
import 'package:catalogoenti/data/session/dao_session_cqrs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

// 📦 COMMAND PROVIDERS

@Riverpod()
Future<MaterialiCommands> materialiCommands(Ref ref) async {
  final db = await ref.watch(databaseManagerProvider.future);
  return MaterialiCommands(db!);
}

@Riverpod()
Future<InterventiCommands> interventiCommands(Ref ref) async {
  final db = await ref.watch(databaseManagerProvider.future);
  return InterventiCommands(db!);
}

@Riverpod()
Future<ContrattiCommands> contrattiCommands(Ref ref) async {
  final db = await ref.watch(databaseManagerProvider.future);
  return ContrattiCommands(db!);
}

@Riverpod()
Future<InterventoContrattiCommands> interventoContrattiCommands(Ref ref) async {
  final db = await ref.watch(databaseManagerProvider.future);
  return InterventoContrattiCommands(db!);
}

@Riverpod()
Future<RepartiCommands> repartiCommands(Ref ref) async {
  final db = await ref.watch(databaseManagerProvider.future);
  return RepartiCommands(db!);
}

// 🔍 QUERY PROVIDERS

@Riverpod()
Future<MaterialiQueries> materialiQueries(Ref ref) async {
  final db = await ref.watch(databaseManagerProvider.future);
  return MaterialiQueries(db!);
}

@Riverpod()
Future<InterventiQueries> interventiQueries(Ref ref) async {
  final db = await ref.watch(databaseManagerProvider.future);
  return InterventiQueries(db!);
}

@Riverpod()
Future<ContrattiQueries> contrattiQueries(Ref ref) async {
  final db = await ref.watch(databaseManagerProvider.future);
  return ContrattiQueries(db!);
}

@Riverpod()
Future<AggregatiQueries> aggregatiQueries(Ref ref) async {
  final db = await ref.watch(databaseManagerProvider.future);
  return AggregatiQueries(db!);
}

@Riverpod()
Future<EntiQueries> entiQueries(Ref ref) async {
  final db = await ref.watch(databaseManagerProvider.future);
  return EntiQueries(db!);
}

@Riverpod()
Future<RepartiQueries> repartiQueries(Ref ref) async {
  final db = await ref.watch(databaseManagerProvider.future);
  return RepartiQueries(db!);
}

@Riverpod()
Future<MaterialiRepartiQueries> materialiRepartiQueries(Ref ref) async {
  final db = await ref.watch(databaseManagerProvider.future);
  return MaterialiRepartiQueries(db!);
}

@Riverpod()
Future<MaterialiRepartiCommands> materialiRepartiCommands(Ref ref) async {
  final db = await ref.watch(databaseManagerProvider.future);
  return MaterialiRepartiCommands(db!);
}

@Riverpod()
Future<CalibrazioniQueries> calibrazioniQueries(Ref ref) async {
  final db = await ref.watch(databaseManagerProvider.future);
  return CalibrazioniQueries(db!);
}

@Riverpod()
Future<DaoSessionCQRS> daoSessionCQRS(Ref ref) async {
  final db = await ref.watch(databaseManagerProvider.future);

  return DaoSessionCQRS(
    calibrazioniQueries: CalibrazioniQueries(db!),
    materialiRepartiCommands: MaterialiRepartiCommands(db),
    materialiRepartiQueries: MaterialiRepartiQueries(db),
    repartiCommands: RepartiCommands(db),
    repartiQueries: RepartiQueries(db),
    entiCommands: EntiCommands(db),
    materialiQueries: MaterialiQueries(db),
    materialiCommands: MaterialiCommands(db),
    interventiQueries: InterventiQueries(db),
    interventiCommands: InterventiCommands(db),
    contrattiQueries: ContrattiQueries(db),
    contrattiCommands: ContrattiCommands(db),
    aggregatiQueries: AggregatiQueries(db),
    entiQueries: EntiQueries(db),
  );
}
