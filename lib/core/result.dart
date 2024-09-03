import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

/// Wrapper class for handling success and failure states.
@immutable
sealed class Result<T extends Object> with EquatableMixin {
  const Result();

  static fromFuture<T extends Object>(
    Future<T> future,
  ) async {
    try {
      final data = await future;
      return Success(data);
    } catch (error, stackTrace) {
      return Failure(error, stackTrace);
    }
  }

  static fromStream<T extends Object>(
    Stream<T> stream,
  ) {
    return stream.map<Result<T>>(
      (data) {
        return Success(data);
      },
    ).onErrorReturnWith(
      (error, stackTrace) {
        return Failure(error, stackTrace);
      },
    );
  }
}

final class Success<T extends Object> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  List<Object> get props => [data];
}

final class Failure<T extends Object> extends Result<T> {
  final Object error;
  final StackTrace stackTrace;

  const Failure(this.error, this.stackTrace);

  @override
  List<Object> get props => [error, stackTrace];
}
