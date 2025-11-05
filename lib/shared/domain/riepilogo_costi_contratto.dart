import 'package:freezed_annotation/freezed_annotation.dart';

part 'riepilogo_costi_contratto.freezed.dart';

@freezed
abstract class RiepilogoCostiContratto with _$RiepilogoCostiContratto {
  const factory RiepilogoCostiContratto({
    required String ente,
    required int numeroInterventi,
    required int totalePezzi,
    required double prezzoUnitarioMedio,
    required double totale,
  }) = _RiepilogoCostiContratto;
}
