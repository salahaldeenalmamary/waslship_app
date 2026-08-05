import '../../../app/providers/dio_provider.dart';
import '../../../data/repositories/dashboard/dashboard_repo.dart';
import '../../../imports/imports.dart';
import 'home_notifier.dart';
import 'home_state.dart';

final dashboardRepoProvider = Provider<DashboardRepo>((ref) {
  final dio = ref.watch(dioProvider);
  return DashboardRepo(dio);
});

final homeNotifierProvider =
    NotifierProvider.autoDispose<HomeNotifier, HomeState>(
      () => HomeNotifier(),
    );
