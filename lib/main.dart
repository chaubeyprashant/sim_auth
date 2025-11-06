import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sim_auth/core/injection/injection.dart';
import 'package:sim_auth/features/login/presentation/bloc/login_bloc.dart';
import 'package:sim_auth/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:sim_auth/features/splash/presentation/pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(
          create: (_) => Injection.splashBloc,
        ),
        BlocProvider<LoginBloc>(
          create: (_) => Injection.loginBloc,
        ),
      ],
      child: MaterialApp(
        title: 'SIM Auth',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const SplashPage(),
      ),
    );
  }
}
