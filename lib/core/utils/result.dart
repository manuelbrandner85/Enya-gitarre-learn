sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  const Failure(this.message, {this.error, this.stackTrace});
}

extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  T? get dataOrNull => switch (this) { Success(:final data) => data, _ => null };
  String? get errorMessage => switch (this) { Failure(:final message) => message, _ => null };

  Result<R> map<R>(R Function(T) transform) => switch (this) {
    Success(:final data) => Success(transform(data)),
    Failure(:final message, :final error, :final stackTrace) =>
      Failure(message, error: error, stackTrace: stackTrace),
  };

  Result<R> flatMap<R>(Result<R> Function(T) transform) => switch (this) {
    Success(:final data) => transform(data),
    Failure(:final message, :final error, :final stackTrace) =>
      Failure(message, error: error, stackTrace: stackTrace),
  };

  T getOrElse(T Function() fallback) => switch (this) {
    Success(:final data) => data,
    Failure() => fallback(),
  };

  Result<T> onSuccess(void Function(T) action) {
    if (this case Success(:final data)) action(data);
    return this;
  }

  Result<T> onFailure(void Function(String, Object?) action) {
    if (this case Failure(:final message, :final error)) action(message, error);
    return this;
  }
}
