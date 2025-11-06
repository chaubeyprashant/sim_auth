import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sim_auth/features/splash/presentation/bloc/splash_event.dart';
import 'package:sim_auth/features/splash/presentation/bloc/splash_state.dart';

/// BLoC for splash screen
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashInitial()) {
    on<StartSplashAnimation>(_onStartSplashAnimation);
    on<SplashAnimationCompleted>(_onSplashAnimationCompleted);
  }

  void _onStartSplashAnimation(
    StartSplashAnimation event,
    Emitter<SplashState> emit,
  ) {
    emit(const SplashAnimationInProgress());
  }

  void _onSplashAnimationCompleted(
    SplashAnimationCompleted event,
    Emitter<SplashState> emit,
  ) {
    emit(const SplashAnimationDone());
  }
}

