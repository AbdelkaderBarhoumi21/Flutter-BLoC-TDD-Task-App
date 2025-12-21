import 'package:dartz/dartz.dart';
import 'package:flutter_task_app/core/error/failures.dart';

/// Base class for all use cases
/// [Type] is the return type
/// [Params] is the input parameters type
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Used when use case doesn't need parameters
class NoParams {
  const NoParams();
}
