import 'package:catalogoenti/data/commands/contratti_commands.dart';
import 'package:catalogoenti/data/commands/enti_commands.dart';
import 'package:catalogoenti/data/commands/interventi_commands.dart';
import 'package:catalogoenti/data/commands/materiali_commands.dart';
import 'package:catalogoenti/data/commands/materiali_reparti_commands.dart';
import 'package:catalogoenti/data/commands/reparti_commands.dart';
import 'package:catalogoenti/data/queries/aggregati_queries.dart';
import 'package:catalogoenti/data/queries/calibrazioni_queries.dart';
import 'package:catalogoenti/data/queries/contratti_queries.dart';
import 'package:catalogoenti/data/queries/enti_queries.dart';
import 'package:catalogoenti/data/queries/interventi_queries.dart';
import 'package:catalogoenti/data/queries/materiali_queries.dart';
import 'package:catalogoenti/data/queries/materiali_reparti_queries.dart';
import 'package:catalogoenti/data/queries/reparti_queries.dart';

class DaoSessionCQRS {
  final MaterialiQueries materialiQueries;
  final MaterialiCommands materialiCommands;
  final InterventiQueries interventiQueries;
  final InterventiCommands interventiCommands;
  final ContrattiQueries contrattiQueries;
  final ContrattiCommands contrattiCommands;
  final AggregatiQueries aggregatiQueries;
  final EntiQueries entiQueries;
  final EntiCommands entiCommands;
  final RepartiCommands repartiCommands;
  final RepartiQueries repartiQueries;
  final MaterialiRepartiQueries materialiRepartiQueries;
  final MaterialiRepartiCommands materialiRepartiCommands;
  final CalibrazioniQueries calibrazioniQueries;

  DaoSessionCQRS({
    required this.calibrazioniQueries,
    required this.materialiRepartiCommands,
    required this.materialiRepartiQueries,
    required this.repartiCommands,
    required this.repartiQueries,
    required this.entiCommands,
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
