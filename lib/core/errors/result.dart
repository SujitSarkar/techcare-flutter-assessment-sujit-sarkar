// Simple Result type representing either a success with a value V
// or a failure with an error E (typically a Failure subtype).
sealed class Result<E, V> {
  const Result();

  bool get isSuccess => this is Success<E, V>;
  bool get isFailure => this is FailureResult<E, V>;

  R fold<R>({required R Function(E error) onFailure, required R Function(V value) onSuccess}) {
    final self = this;
    if (self is Success<E, V>) return onSuccess(self.value);
    final failure = self as FailureResult<E, V>;
    return onFailure(failure.error);
  }
}

class Success<E, V> extends Result<E, V> {
  final V value;
  const Success(this.value);
}

class FailureResult<E, V> extends Result<E, V> {
  final E error;
  const FailureResult(this.error);
}
