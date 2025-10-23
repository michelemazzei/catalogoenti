import 'package:catalogoenti/data/database/app_database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'materiale_con_ultimo_intervento.freezed.dart';

@freezed
abstract class MaterialeConUltimoIntervento
    with _$MaterialeConUltimoIntervento {
  const factory MaterialeConUltimoIntervento({
    required Materiale materiale,
    DateTime? ultimoIntervento,
  }) = _MaterialeConUltimoIntervento;
}
