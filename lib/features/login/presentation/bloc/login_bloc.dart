import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sim_auth/features/login/domain/usecases/check_phone_permission.dart';
import 'package:sim_auth/features/login/domain/usecases/get_sim_cards.dart';
import 'package:sim_auth/features/login/domain/usecases/request_phone_permission.dart';
import 'package:sim_auth/features/login/presentation/bloc/login_event.dart';
import 'package:sim_auth/features/login/presentation/bloc/login_state.dart';

/// BLoC for login page
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final CheckPhonePermissionUseCase checkPhonePermissionUseCase;
  final RequestPhonePermissionUseCase requestPhonePermissionUseCase;
  final GetSimCardsUseCase getSimCardsUseCase;

  LoginBloc({
    required this.checkPhonePermissionUseCase,
    required this.requestPhonePermissionUseCase,
    required this.getSimCardsUseCase,
  }) : super(const LoginInitial()) {
    on<CheckPhonePermission>(_onCheckPhonePermission);
    on<RequestPhonePermission>(_onRequestPhonePermission);
    on<GetSimCards>(_onGetSimCards);
    on<SelectSimCard>(_onSelectSimCard);
    on<ContinueWithPhoneNumber>(_onContinueWithPhoneNumber);
  }

  Future<void> _onCheckPhonePermission(
    CheckPhonePermission event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());
    final result = await checkPhonePermissionUseCase();
    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (hasPermission) => emit(PhonePermissionChecked(hasPermission)),
    );
  }

  Future<void> _onRequestPhonePermission(
    RequestPhonePermission event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());
    final result = await requestPhonePermissionUseCase();
    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (hasPermission) => emit(PhonePermissionChecked(hasPermission)),
    );
  }

  Future<void> _onGetSimCards(
    GetSimCards event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());
    final result = await getSimCardsUseCase();
    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (simCards) => emit(SimCardsLoaded(simCards: simCards)),
    );
  }

  void _onSelectSimCard(
    SelectSimCard event,
    Emitter<LoginState> emit,
  ) {
    if (state is SimCardsLoaded) {
      final currentState = state as SimCardsLoaded;
      emit(currentState.copyWith(
        selectedPhoneNumber: event.simCard.phoneNumber,
      ));
    }
  }

  void _onContinueWithPhoneNumber(
    ContinueWithPhoneNumber event,
    Emitter<LoginState> emit,
  ) {
    if (event.phoneNumber.trim().isEmpty) {
      emit(const LoginError('Please enter a mobile number'));
      return;
    }
    emit(LoginSuccess(event.phoneNumber));
  }
}

