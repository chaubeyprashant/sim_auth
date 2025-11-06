import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sim_auth/features/login/presentation/pages/login_page.dart';
import 'package:sim_auth/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:sim_auth/features/splash/presentation/bloc/splash_event.dart';
import 'package:sim_auth/features/splash/presentation/bloc/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create a bounce animation using Tween with Curves.bounceOut
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    ));

    // Start the animation
    _controller.forward();

    // Listen for animation completion
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.read<SplashBloc>().add(const SplashAnimationCompleted());
      }
    });

    // Start splash animation
    context.read<SplashBloc>().add(const StartSplashAnimation());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashAnimationDone) {
          // Navigate to Login Page after animation completes
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ScaleTransition(
            scale: _bounceAnimation,
            child: Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to a placeholder icon if image is not found
                return Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.phone_android,
                    size: 80,
                    color: Colors.blue.shade700,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

