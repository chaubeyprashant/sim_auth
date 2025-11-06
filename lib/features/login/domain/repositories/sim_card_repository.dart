import 'package:sim_auth/core/errors/failures.dart';
import 'package:sim_auth/features/login/domain/entities/sim_card_entity.dart';
import 'package:dartz/dartz.dart';

/// Repository interface for SIM card operations
abstract class SimCardRepository {
  /// Check if phone permission is granted
  Future<Either<Failure, bool>> hasPhonePermission();

  /// Request phone permission
  Future<Either<Failure, bool>> requestPhonePermission();

  /// Get all SIM cards
  Future<Either<Failure, List<SimCardEntity>>> getSimCards();
}



