import 'package:interview_flutter/domain/core/app_error.dart';

/// Utility class that simplifies handling errors.
///
/// Return a [Result] from a function to indicate success or failure.
///
/// A [Result] is either an [Success] with a value of type [T]
/// or a [Failure] with an [AppError].
///
/// Evaluate the result using a switch statement:
/// ```dart
/// switch (result) {
///   case Success():
///     print(result.value);
///   case Failure():
///     print(result.error);
/// }
/// ```
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
}

/// Subclass of Result for values
final class Success<T> extends Result<T> {
  /// Returned value in result
  final T value;

  const Success(this.value);

  @override
  String toString() => 'Result<$T>.success($value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Success<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// Subclass of Result for errors
final class Failure<T> extends Result<T> {
  /// Returned error in result
  final AppError error;

  const Failure(this.error);

  factory Failure.fromException(Object exception) {
    return Failure(AppError.from(exception));
  }

  @override
  String toString() => 'Result<$T>.failure($error)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Failure<T> && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

/// Used instead of `void` as a return statement for a function
/// when no value is to be returned.
///
/// There is only one value of type [Unit].
final class Unit {
  static const Unit _instance = Unit._();
  const Unit._();
  factory Unit() => _instance;

  @override
  String toString() => '()';

  @override
  bool operator ==(Object other) => other is Unit;

  @override
  int get hashCode => 0;
}
