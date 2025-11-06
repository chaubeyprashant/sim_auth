import 'package:dartz/dartz.dart';
import 'package:sim_auth/core/errors/exceptions.dart';
import 'package:sim_auth/core/errors/failures.dart';
import 'package:sim_auth/features/login/data/datasources/sim_card_remote_data_source.dart';
import 'package:sim_auth/features/login/domain/entities/sim_card_entity.dart';
import 'package:sim_auth/features/login/domain/repositories/sim_card_repository.dart';

/// Repository implementation for SIM card operations
class SimCardRepositoryImpl implements SimCardRepository {
  final SimCardRemoteDataSource remoteDataSource;

  SimCardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> hasPhonePermission() async {
    try {
      final result = await remoteDataSource.hasPhonePermission();
      return Right(result);
    } on PermissionException catch (e) {
      return Left(PermissionFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> requestPhonePermission() async {
    try {
      final result = await remoteDataSource.requestPhonePermission();
      return Right(result);
    } on PermissionException catch (e) {
      return Left(PermissionFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<SimCardEntity>>> getSimCards() async {
    try {
      final simCardModels = await remoteDataSource.getSimCards();
      final simCardEntities = simCardModels.map((model) => model.toEntity()).toList();
      return Right(simCardEntities);
    } on NoSimCardException catch (e) {
      return Left(NoSimCardFailure(e.message));
    } on PermissionException catch (e) {
      return Left(PermissionFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}



