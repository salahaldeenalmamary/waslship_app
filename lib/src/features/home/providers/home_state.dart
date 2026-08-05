import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/dashboard/dashboard_dtos.dart';

class HomeState {
  final AsyncValue<DashboardOverviewDto> overview;

  const HomeState({
    this.overview = const AsyncValue.loading(),
  });

  HomeState copyWith({AsyncValue<DashboardOverviewDto>? overview}) {
    return HomeState(overview: overview ?? this.overview);
  }

  // ── Convenient pass-through getters ─────────────────────────────
  int get total => overview.value?.statistics.total ?? 0;
  int get delivered => overview.value?.statistics.delivered ?? 0;
  int get inTransit => overview.value?.statistics.inTransit ?? 0;
  int get failed => overview.value?.statistics.failed ?? 0;
  int get pending => overview.value?.statistics.pending ?? 0;
  int get cancelled => overview.value?.statistics.cancelled ?? 0;
  double get codTotal => overview.value?.statistics.codTotal ?? 0.0;
  String get serviceStatus => overview.value?.serviceStatus ?? '';
}
