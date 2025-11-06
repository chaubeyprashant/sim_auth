import 'package:dartz/dartz.dart';
import 'package:sim_auth/core/errors/failures.dart';
import 'package:sim_auth/core/usecases/usecase.dart';
import 'package:sim_auth/features/login/domain/repositories/sim_card_repository.dart';

/// Use case to request phone permission
class RequestPhonePermissionUseCase extends UseCaseNoParamsEither<Either<Failure, bool>> {
  final SimCardRepository repository;

  RequestPhonePermissionUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call() {
    return repository.requestPhonePermission();
  }
}

