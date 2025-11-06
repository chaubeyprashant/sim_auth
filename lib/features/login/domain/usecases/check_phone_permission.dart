import 'package:dartz/dartz.dart';
import 'package:sim_auth/core/errors/failures.dart';
import 'package:sim_auth/core/usecases/usecase.dart';
import 'package:sim_auth/features/login/domain/repositories/sim_card_repository.dart';

/// Use case to check phone permission
class CheckPhonePermissionUseCase extends UseCaseNoParamsEither<Either<Failure, bool>> {
  final SimCardRepository repository;

  CheckPhonePermissionUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call() {
    return repository.hasPhonePermission();
  }
}

