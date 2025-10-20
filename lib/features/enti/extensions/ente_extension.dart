import 'package:catalogoenti/data/database/app_database.dart';

extension EnteFiltro on Ente {
  bool contiene(String filtro) {
    final f = filtro.toLowerCase();
    return nome.toLowerCase().contains(f);
  }
}
