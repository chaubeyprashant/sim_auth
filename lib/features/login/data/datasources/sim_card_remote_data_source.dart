import 'package:mobile_number/mobile_number.dart';
import 'package:sim_auth/core/errors/exceptions.dart';
import 'package:sim_auth/features/login/data/models/sim_card_model.dart';

/// Remote data source for SIM card operations
abstract class SimCardRemoteDataSource {
  Future<bool> hasPhonePermission();
  Future<bool> requestPhonePermission();
  Future<List<SimCardModel>> getSimCards();
}

class SimCardRemoteDataSourceImpl implements SimCardRemoteDataSource {
  @override
  Future<bool> hasPhonePermission() async {
    try {
      final hasPermission = await MobileNumber.hasPhonePermission;
      return hasPermission ?? false;
    } catch (e) {
      throw PermissionException('Failed to check phone permission: $e');
    }
  }

  @override
  Future<bool> requestPhonePermission() async {
    try {
      await MobileNumber.requestPhonePermission;
      final hasPermission = await MobileNumber.hasPhonePermission;
      return hasPermission ?? false;
    } catch (e) {
      throw PermissionException('Failed to request phone permission: $e');
    }
  }

  @override
  Future<List<SimCardModel>> getSimCards() async {
    try {
      final future = MobileNumber.getSimCards;
      if (future == null) {
        throw NoSimCardException('SIM card access not available on this device');
      }

      final simCards = await future;
      
      if (simCards.isEmpty) {
        throw NoSimCardException('No SIM cards found on this device');
      }

      return simCards.map((simCard) {
        return SimCardModel.fromDynamic(simCard);
      }).toList();
    } catch (e) {
      if (e is NoSimCardException) {
        rethrow;
      }
      throw ServerException('Failed to get SIM cards: $e');
    }
  }
}



