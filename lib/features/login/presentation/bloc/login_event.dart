import 'package:equatable/equatable.dart';
import 'package:sim_auth/features/login/domain/entities/sim_card_entity.dart';

/// Base class for login events
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check phone permission
class CheckPhonePermission extends LoginEvent {
  const CheckPhonePermission();
}

/// Event to request phone permission
class RequestPhonePermission extends LoginEvent {
  const RequestPhonePermission();
}

/// Event to get SIM cards
class GetSimCards extends LoginEvent {
  const GetSimCards();
}

/// Event to select a SIM card
class SelectSimCard extends LoginEvent {
  final SimCardEntity simCard;

  const SelectSimCard(this.simCard);

  @override
  List<Object?> get props => [simCard];
}

/// Event to continue with phone number
class ContinueWithPhoneNumber extends LoginEvent {
  final String phoneNumber;

  const ContinueWithPhoneNumber(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}



