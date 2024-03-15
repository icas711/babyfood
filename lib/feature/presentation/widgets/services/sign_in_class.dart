import 'dart:async';

import 'package:babyfood/feature/presentation/widgets/services/snak_bar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class signIn {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const signIn({
    required this.emailController,
    required this.passwordController,
  });

  Future<void> signInAsync(BuildContext context, VoidCallback onSuccess) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }

      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        unawaited(SnackBarService.showSnackBar(
          context,
          'Неправильный email или пароль. Повторите попытку',
          true,
        ));
        return;
      } else {
        unawaited(SnackBarService.showSnackBar(
          context,
          'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
          true,
        ));
        return;
      }
    }
    onSuccess.call();
  }
}
