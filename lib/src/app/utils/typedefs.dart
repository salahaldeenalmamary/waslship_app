// File: lib/core/utils/either.dart

import '../../imports/imports.dart';

/// Simple Either type to handle success/failure without fpdart
sealed class Either<L, R> {
  const Either();

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;

  L get left => (this as Left<L, R>).value;
  R get right => (this as Right<L, R>).value;

  T fold<T>(T Function(L l) leftFn, T Function(R r) rightFn) {
    switch (this) {
      case Left(value: final l):
        return leftFn(l);
      case Right(value: final r):
        return rightFn(r);
    }
  }

  Either<L, T> map<T>(T Function(R r) f) {
    return fold((l) => Left(l), (r) => Right(f(r)));
  }

  Either<T, R> mapLeft<T>(T Function(L l) f) {
    return fold((l) => Left(f(l)), (r) => Right(r));
  }

  Future<Either<L, T>> asyncMap<T>(Future<T> Function(R r) f) async {
    return fold((l) => Left(l), (r) async => Right(await f(r)));
  }

  R getOrElse(R Function(L l) orElse) {
    return fold((l) => orElse(l), (r) => r);
  }

  /// Pattern matching convenience methods
  void when({
    required void Function(L l) left,
    required void Function(R r) right,
  }) {
    fold(left, right);
  }
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Left && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Right && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Helper functions for creating Either instances (mimics fpdart)
Either<L, R> left<L, R>(L l) => Left(l);
Either<L, R> right<L, R>(R r) => Right(r);
// File: lib/core/utils/typedefs.dart

/// Type alias for Either with Failure on left and T on right
typedef FutureEither<T> = Future<Either<Failure, T>>;

/// Type alias for Either with Failure on left and void on right
typedef FutureEitherVoid = FutureEither<void>;

/// Type alias for Stream of Either
typedef StreamEither<T> = Stream<Either<Failure, T>>;
