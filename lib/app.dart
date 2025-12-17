import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket_app/blocs/auth/auth_bloc.dart';
import 'package:supermarket_app/screens/splash/splash_screen.dart';
import 'package:supermarket_app/screens/auth/login_screen.dart';
import 'package:supermarket_app/screens/home/home_screen.dart';
import 'package:supermarket_app/utils/constants.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const SplashScreen();
        } else if (state is AuthAuthenticated) {
          return const HomeScreen();
        } else if (state is AuthUnauthenticated) {
          return const LoginScreen();
        }
        return const SplashScreen();
      },
    );
  }
}