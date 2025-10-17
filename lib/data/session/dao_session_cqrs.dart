import 'package:catalogoenti/data/commands/contratti_commands.dart';
import 'package:catalogoenti/data/commands/interventi_commands.dart';
import 'package:catalogoenti/data/commands/materiali_commands.dart';
import 'package:catalogoenti/data/queries/aggregati_queries.dart';
import 'package:catalogoenti/data/queries/contratti_queries.dart';
import 'package:catalogoenti/data/queries/enti_queries.dart';
import 'package:catalogoenti/data/queries/interventi_queries.dart';
import 'package:catalogoenti/data/queries/materiali_queries.dart';

class DaoSessionCQRS {
  final MaterialiQueries materialiQueries;
  final MaterialiCommands materialiCommands;
  final InterventiQueries interventiQueries;
  final InterventiCommands interventiCommands;
  final ContrattiQueries contrattiQueries;
  final ContrattiCommands contrattiCommands;
  final AggregatiQueries aggregatiQueries;
  final EntiQueries entiQueries;

  DaoSessionCQRS({
    required this.materialiQueries,
    required this.materialiCommands,
    required this.interventiQueries,
    required this.interventiCommands,
    required this.contrattiQueries,
    required this.contrattiCommands,
    required this.aggregatiQueries,
    required this.entiQueries,
  });
}
