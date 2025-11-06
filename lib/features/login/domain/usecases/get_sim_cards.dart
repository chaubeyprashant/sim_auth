import 'package:dartz/dartz.dart';
import 'package:sim_auth/core/errors/failures.dart';
import 'package:sim_auth/core/usecases/usecase.dart';
import 'package:sim_auth/features/login/domain/entities/sim_card_entity.dart';
import 'package:sim_auth/features/login/domain/repositories/sim_card_repository.dart';

/// Use case to get all SIM cards
class GetSimCardsUseCase extends UseCaseNoParamsEither<Either<Failure, List<SimCardEntity>>> {
  final SimCardRepository repository;

  GetSimCardsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SimCardEntity>>> call() {
    return repository.getSimCards();
  }
}

