import 'package:babyfood/feature/presentation/pages/user/account_screen.dart';
import 'package:babyfood/feature/presentation/pages/user/login_screen.dart';
import 'package:babyfood/feature/presentation/pages/user/verify_email_screen.dart';
import 'package:babyfood/feature/presentation/pages/user/upload_screen.dart';
import 'package:babyfood/feature/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (user) {

        print('auth_checker');
        if (user != null) {
          //ref.read(authRepositoryProvider).reload();
          final emailVerified = ref.watch(authRepositoryProvider).emailVerified;
          if (!emailVerified) {
            return const VerifyEmailScreen();
          }
          return const AccountScreen();
        }
        return LoginScreen();
      },
      error: (e, trace) => LoginScreen(),
      loading: () => const SplashScreen2(),
    );
  }
}

class SplashScreen2 extends StatelessWidget {
  const SplashScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
