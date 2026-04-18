import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/presentation/bloc/auth/auth_cubit.dart';
import 'package:smart_threads/presentation/bloc/auth/auth_state.dart';
import 'package:smart_threads/presentation/screens/auth_screen.dart';
import 'package:smart_threads/presentation/screens/feed_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.initial) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state.status == AuthStatus.authenticated) return const FeedScreen();

        return const AuthScreen();
      },
    );
  }
}
