import 'package:logging/logging.dart';

class LoggerService {
  final Logger _logger;

  LoggerService(String name) : _logger = Logger(name);

  void info(String message) => _logger.info(message);
  void warning(String message) => _logger.warning(message);
  void error(String message) => _logger.severe(message);
  void debug(String message) => _logger.fine(message);
}
