import 'package:equatable/equatable.dart';

/// Base class for splash events
abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start splash animation
class StartSplashAnimation extends SplashEvent {
  const StartSplashAnimation();
}

/// Event when splash animation completes
class SplashAnimationCompleted extends SplashEvent {
  const SplashAnimationCompleted();
}



