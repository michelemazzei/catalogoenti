import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.freezed.dart';

@freezed
abstract class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    required int entiCount,
    required int materialiCount,
    required int inScadenzaCount,
    required int daCalibrareCount,
    required int contrattiCount,
  }) = _DashboardStats;
}
