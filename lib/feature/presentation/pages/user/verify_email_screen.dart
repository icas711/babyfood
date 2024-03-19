import 'dart:async';

import 'package:babyfood/feature/presentation/providers/auth_provider.dart';
import 'package:babyfood/feature/presentation/widgets/services/snak_bar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;

   Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    sendVerificationEmail();
       if (!isEmailVerified) {

      timer = Timer.periodic(
        const Duration(seconds: 3),
            (_) async {
          final isVerified=await checkEmailVerified();
          if(isVerified){
            timer?.cancel();

          }
            },
      );
    }
  }

  @override
  void dispose() {
     timer?.cancel();
    super.dispose();
  }

  Future<bool> checkEmailVerified() async {
    await ref.read(authRepositoryProvider).reload().then((value) =>
    ref.watch(authRepositoryProvider).emailVerified?timer?.cancel():null
    );

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    return isEmailVerified;
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 15));

      setState(() => canResendEmail = true);
    } catch (e) {
      print(e);
      if (mounted) {
        SnackBarService.showSnackBar(
          context,
          '$e',
          //'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
          true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Верификация Email адреса'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const Text(
                  'Письмо с подтверждением было отправлено на вашу электронную почту.',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                  icon: const Icon(Icons.email),
                  label: const Text('Повторно отправить'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    // timer?.cancel();
                    await FirebaseAuth.instance.currentUser!.delete();
                  },
                  child: const Text(
                    'Отменить',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

    );
    return Container();
  }
}

