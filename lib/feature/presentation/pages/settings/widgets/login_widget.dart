import 'dart:async';

import 'package:babyfood/feature/presentation/widgets/services/sign_in_class.dart';
import 'package:babyfood/feature/presentation/widgets/services/snak_bar_service.dart';
import 'package:babyfood/feature/presentation/widgets/wm/login_controller.dart';
import 'package:babyfood/feature/presentation/widgets/wm/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginWidget extends ConsumerStatefulWidget {
  const LoginWidget({super.key});

  @override
  LoginWidgetState createState() => LoginWidgetState();
}

class LoginWidgetState extends ConsumerState<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isHiddenPassword = true;
  bool validateEmail = true;
  final formKey = GlobalKey<FormState>();

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  bool validator(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginControllerProvider, (previous, next) {
      if(next is LoginStateError){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error),backgroundColor: Colors.red,));
      }
    });
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              controller: emailController,
              validator: (email) => !validator(email!)
                  ? 'Введите правильный Email'
                  : null,
              decoration: InputDecoration(
                fillColor: Colors.grey.shade200,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                hintText: 'Введите Email',
                filled: true,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              autocorrect: false,
              controller: passwordController,
              obscureText: isHiddenPassword,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                fillColor: Colors.grey.shade200,
                filled: true,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                hintText: 'Введите пароль',
                suffix: InkWell(
                  onTap: togglePasswordView,
                  child: Icon(
                    isHiddenPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    final isValid = formKey.currentState!.validate();
                    if (!isValid) return;
                    ref.read(loginControllerProvider.notifier)
                        .login(emailController.text.trim(), passwordController.text.trim());
                    /*final isValid = formKey.currentState!.validate();
                    if (!isValid) return;
                    unawaited(signIn(
                      emailController: emailController,
                      passwordController: passwordController,
                    ).signInAsync(context, () {
                      if (!mounted) return;
                      context.goNamed('home');
                    }));*/
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Еще не зарегистирровались? ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    context.goNamed('signup');
                  },
                  child: const Text(
                    'Создать аккаунт',
                    style:
                        TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/reset_password'),
              child: const Text('Сбросить пароль'),
            ),
          ],
        ),
      ),
    );
  }

}

