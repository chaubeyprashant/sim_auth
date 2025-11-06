import 'package:equatable/equatable.dart';

/// Base class for all use cases
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Base class for use cases that don't require parameters
abstract class UseCaseNoParams<Type> {
  Future<Type> call();
}

/// Base class for use cases that return Either
abstract class UseCaseEither<Type, Params> {
  Future<Type> call(Params params);
}

/// Base class for use cases that don't require parameters and return Either
abstract class UseCaseNoParamsEither<Type> {
  Future<Type> call();
}

/// No parameters class for use cases that don't need parameters
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

