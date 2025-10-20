import 'package:catalogoenti/data/database/app_database.dart';

extension MaterialeFiltro on Materiale {
  bool contiene(String filtro) {
    final f = filtro.toLowerCase();
    return partNumber.toLowerCase().contains(f) ||
        nsn.toLowerCase().contains(f) ||
        denominazione.toLowerCase().contains(f);
  }
}
