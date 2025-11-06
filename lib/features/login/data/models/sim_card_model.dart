import 'package:sim_auth/features/login/domain/entities/sim_card_entity.dart';

/// SIM Card data model
class SimCardModel extends SimCardEntity {
  const SimCardModel({
    required super.phoneNumber,
    super.carrierName,
    super.slotIndex,
  });

  /// Factory constructor to create SimCardModel from dynamic data
  factory SimCardModel.fromDynamic(dynamic data) {
    return SimCardModel(
      phoneNumber: data.line1Number ?? 
                  data.number ?? 
                  data.phoneNumber ?? 
                  'Unknown',
      carrierName: data.carrierName,
      slotIndex: data.slotIndex,
    );
  }

  /// Convert to entity
  SimCardEntity toEntity() {
    return SimCardEntity(
      phoneNumber: phoneNumber,
      carrierName: carrierName,
      slotIndex: slotIndex,
    );
  }
}



