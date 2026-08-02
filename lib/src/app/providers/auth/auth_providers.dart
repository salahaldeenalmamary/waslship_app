import '../../../imports/imports.dart';
import '../dio_provider.dart';
import '../../../data/repositories/auth/auth_repo.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

final authRepoProvider = Provider<AuthRepo>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepo(dio);
});

// AuthNotifier provider - THE MAIN PROVIDER
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final authRepo = ref.watch(authRepoProvider);
  return AuthNotifier(authRepo);
});
