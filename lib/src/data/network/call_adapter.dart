import 'package:retrofit/retrofit.dart';
import 'result.dart';

/// Retrofit [CallAdapter] that wraps every `Future<T>` endpoint response
/// into a `Future<Result<T>>`.
///
/// Apply class-wide via:
/// ```dart
/// @RestApi(callAdapter: ApiResultAdapter)
/// abstract class BookingsRepo { ... }
/// ```
///
/// Or per-method via:
/// ```dart
/// @UseCallAdapter(ApiResultAdapter)
/// @GET('/bookings')
/// Future<Result<List<BookingDto>>> getBookings();
/// ```
class ApiResultAdapter<T> extends CallAdapter<Future<T>, Future<Result<T>>> {
  
  @override
  Future<Result<T>> adapt(Future<T> Function() call) async {
    try {
      final response = await call();
      return Result<T>.ok(response);
    } catch (e) {
      return Result.err(e.toString(), cause: e);
    }
  }
}
