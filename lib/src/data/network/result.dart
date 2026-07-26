/// A sealed result type representing either a successful [Ok] value
/// or an [Err] failure.
sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok<T>;
  const factory Result.err(String message, {Object? cause}) = Err<T>;

  // ── Helpers ──────────────────────────────────────────────────────────────

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  T get requireValue => (this as Ok<T>).value;
  String get requireError => (this as Err<T>).message;

  /// Transforms the value if [Ok], passes through [Err] unchanged.
  Result<U> map<U>(U Function(T value) transform) => switch (this) {
    Ok(:final value) => Result.ok(transform(value)),
    Err(:final message, :final cause) => Err<U>(message, cause: cause),
  };

  /// Chains result-returning operations.
  Result<U> flatMap<U>(Result<U> Function(T value) transform) => switch (this) {
    Ok(:final value) => transform(value),
    Err(:final message, :final cause) => Err<U>(message, cause: cause),
  };

  /// Executes [onOk] or [onErr] depending on the variant.
  R fold<R>({
    required R Function(T value) onOk,
    required R Function(String message, Object? cause) onErr,
  }) => switch (this) {
    Ok(:final value) => onOk(value),
    Err(:final message, :final cause) => onErr(message, cause),
  };

  /// Returns [value] if [Ok], or [fallback] otherwise.
  T getOrElse(T fallback) => switch (this) {
    Ok(:final value) => value,
    Err() => fallback,
  };
}

/// Successful variant of [Result].
final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;

  @override
  String toString() => 'Ok($value)';
}

/// Error variant of [Result].
final class Err<T> extends Result<T> {
  const Err(this.message, {this.cause});
  final String message;
  final Object? cause;

  @override
  String toString() => 'Err($message)';
}
