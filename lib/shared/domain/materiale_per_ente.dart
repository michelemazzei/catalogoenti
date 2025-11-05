import 'package:freezed_annotation/freezed_annotation.dart';
part 'materiale_per_ente.freezed.dart';

@freezed
abstract class MaterialePerEnte with _$MaterialePerEnte {
  const factory MaterialePerEnte({
    required int id,
    required String ente,
    required int enteId,
    required String reparto,
    required String localita,
    required String partNumber,
    required String denominazione,
    required String nsn,
    required String note,
  }) = _MaterialePerEnte;
}
