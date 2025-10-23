import 'package:freezed_annotation/freezed_annotation.dart';

part 'pezzo_riparato.freezed.dart';

@freezed
abstract class PezzoRiparato with _$PezzoRiparato {
  factory PezzoRiparato({
    required int id,
    required int quantita,
    required int periodicita,
    required String denominazione,
    required String partNumber,
    required String? nsn,
    required DateTime? data,
    required double? costo,
  }) = _PezzoRipato;
}
