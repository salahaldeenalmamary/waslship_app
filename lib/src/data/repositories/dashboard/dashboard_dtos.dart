import 'package:json_annotation/json_annotation.dart';

part 'dashboard_dtos.g.dart';

@JsonSerializable()
class DashboardStatisticsDto {
  final int total;
  final int delivered;
  final int inTransit;
  final int failed;
  final int pending;
  final int cancelled;
  final double codTotal;

  const DashboardStatisticsDto({
    required this.total,
    required this.delivered,
    required this.inTransit,
    required this.failed,
    required this.pending,
    required this.cancelled,
    required this.codTotal,
  });

  factory DashboardStatisticsDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatisticsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardStatisticsDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DashboardOverviewDto {
  final DashboardStatisticsDto statistics;
  final String serviceStatus;
  final String lastUpdated;

  const DashboardOverviewDto({
    required this.statistics,
    required this.serviceStatus,
    required this.lastUpdated,
  });

  factory DashboardOverviewDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardOverviewDtoFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardOverviewDtoToJson(this);
}
