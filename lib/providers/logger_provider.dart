import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:catalogoenti/services/logger_service.dart';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';

part 'logger_provider.g.dart';

@Riverpod(keepAlive: true)
LoggerService logger(Ref ref) {
  // Inizializzazione globale del sistema di logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint(
      '[${record.level.name}] ${record.time}: ${record.loggerName} → ${record.message}',
    );
  });

  return LoggerService('CatalogoEnti');
}
