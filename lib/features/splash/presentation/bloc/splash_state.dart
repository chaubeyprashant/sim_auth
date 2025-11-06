import 'package:equatable/equatable.dart';

/// Base class for splash states
abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SplashInitial extends SplashState {
  const SplashInitial();
}

/// Animation is in progress
class SplashAnimationInProgress extends SplashState {
  const SplashAnimationInProgress();
}

/// Animation completed, ready to navigate
class SplashAnimationDone extends SplashState {
  const SplashAnimationDone();
}

