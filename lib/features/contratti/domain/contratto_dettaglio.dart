import 'package:catalogoenti/data/database/app_database.dart';
import 'package:catalogoenti/shared/domain/pezzo_riparato.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'contratto_dettaglio.freezed.dart';

@freezed
abstract class ContrattoDettaglio with _$ContrattoDettaglio {
  factory ContrattoDettaglio({
    required Contratto contratto,
    required List<PezzoRiparato> pezziRiparati,
    required double costoTotale,
  }) = _ContrattoDettaglio;
}
