import 'package:equatable/equatable.dart';
import 'package:sim_auth/features/login/domain/entities/sim_card_entity.dart';

/// Base class for login states
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// Loading state
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Phone permission checked
class PhonePermissionChecked extends LoginState {
  final bool hasPermission;

  const PhonePermissionChecked(this.hasPermission);

  @override
  List<Object?> get props => [hasPermission];
}

/// SIM cards loaded
class SimCardsLoaded extends LoginState {
  final List<SimCardEntity> simCards;
  final String? selectedPhoneNumber;

  const SimCardsLoaded({
    required this.simCards,
    this.selectedPhoneNumber,
  });

  SimCardsLoaded copyWith({
    List<SimCardEntity>? simCards,
    String? selectedPhoneNumber,
  }) {
    return SimCardsLoaded(
      simCards: simCards ?? this.simCards,
      selectedPhoneNumber: selectedPhoneNumber ?? this.selectedPhoneNumber,
    );
  }

  @override
  List<Object?> get props => [simCards, selectedPhoneNumber];
}

/// Error state
class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Success state (continue button pressed)
class LoginSuccess extends LoginState {
  final String phoneNumber;

  const LoginSuccess(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}



