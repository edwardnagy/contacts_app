import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

typedef ResultT = Object?;

/// Wrapper class for handling success and failure states.
@immutable
sealed class Result<T extends ResultT> with EquatableMixin {
  const Result();

  static Future<Result<T>> fromFuture<T extends ResultT>(
    Future<T> future,
  ) async {
    try {
      final data = await future;
      return ResultSuccess<T>(data);
    } catch (error, stackTrace) {
      return ResultFailure<T>(error, stackTrace);
    }
  }

  static Stream<Result<T>> fromStream<T extends ResultT>(
    Stream<T> stream,
  ) {
    return stream.map<Result<T>>(
      (data) {
        return ResultSuccess<T>(data);
      },
    ).onErrorReturnWith(
      (error, stackTrace) {
        return ResultFailure<T>(error, stackTrace);
      },
    );
  }
}

final class ResultSuccess<T extends ResultT> extends Result<T> {
  final T data;

  const ResultSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

final class ResultFailure<T extends ResultT> extends Result<T> {
  final Object error;
  final StackTrace stackTrace;

  const ResultFailure(this.error, this.stackTrace);

  @override
  List<Object?> get props => [error, stackTrace];
}
