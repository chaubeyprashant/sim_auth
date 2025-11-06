import 'package:equatable/equatable.dart';

/// SIM Card entity
class SimCardEntity extends Equatable {
  final String phoneNumber;
  final String? carrierName;
  final int? slotIndex;

  const SimCardEntity({
    required this.phoneNumber,
    this.carrierName,
    this.slotIndex,
  });

  @override
  List<Object?> get props => [phoneNumber, carrierName, slotIndex];
}



