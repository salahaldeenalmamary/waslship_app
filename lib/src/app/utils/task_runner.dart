import '../../imports/imports.dart';
import 'typedefs.dart';

/// Type alias for Either with Failure on left and T on right
typedef FutureEither<T> = Future<Either<Failure, T>>;

/// Run task returning Either directly
FutureEither<T> runTask<T>(
  Future<T> Function() action, {
  bool requiresNetwork = false,
}) async {
  if (requiresNetwork) {
    final hasNetwork = await InternetConnectionService().hasConnection();

    if (!hasNetwork) {
      AppLogger.warning('Network unavailable for task');
      showGlobalToast(
        message:
            'No internet connection. Please check your connection and try again.',
        status: 'warning',
      );
      return Left(
        const NetworkFailure(
          'No internet connection. Please check your connection and try again.',
        ),
      );
    }
  }

  try {
    final result = await action();
    return Right(result);
  } catch (error, stackTrace) {
    AppLogger.error('Task execution failed: $error', [error, stackTrace]);
    final errorMessage = AppErrorHandler.format(error);
    return Left(ServerFailure(errorMessage, error: error));
  }
}
