import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/dashboard/dashboard_repo.dart';
import 'home_providers.dart';
import 'home_state.dart';

class HomeNotifier extends Notifier<HomeState> {
  late final DashboardRepo _repo;

  @override
  HomeState build() {
    _repo = ref.read(dashboardRepoProvider);
    Future.microtask(loadOverview);
    return const HomeState();
  }

  Future<void> loadOverview() async {
    state = state.copyWith(overview: const AsyncValue.loading());

    final result = await _repo.getDashboardOverview();

    result.fold(
      onOk: (response) {
        final data = response.data;
        if (data != null) {
          state = state.copyWith(overview: AsyncValue.data(data));
        } else {
          state = state.copyWith(
            overview: AsyncValue.error('لا توجد بيانات', StackTrace.current),
          );
        }
      },
      onErr: (message, _) {
        state = state.copyWith(
          overview: AsyncValue.error(message, StackTrace.current),
        );
      },
    );
  }

  Future<void> refresh() => loadOverview();
}
