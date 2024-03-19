import 'package:babyfood/feature/presentation/widgets/wm/login_controller.dart';
import 'package:babyfood/feature/presentation/widgets/wm/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends ConsumerState<SignUpScreen> {
  bool isHiddenPassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordTextRepeatInputController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool validateEmail = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordTextRepeatInputController.dispose();

    super.dispose();
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
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
      if(next is SentVerifyEmailState)
        {
          context.goNamed('account');
        }

    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Зарегистрироваться'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                controller: emailController,
                validator: (email) =>
                    !validator(email!) ? 'Введите правильный Email' : null,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  hintText: 'Введите Email',
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                autocorrect: false,
                controller: passwordController,
                obscureText: isHiddenPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Минимум 6 символов'
                    : null,
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
              const SizedBox(height: 16),
              TextFormField(
                autocorrect: false,
                controller: passwordTextRepeatInputController,
                obscureText: isHiddenPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && passwordController.text !=value
                    ? 'Пароли должны совпадать'
                    : null,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  hintText: 'Введите пароль еще раз',
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
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  final isValid = formKey.currentState!.validate();
                  if (!isValid) return;
                  ref.read(loginControllerProvider.notifier).signUp(emailController.text.trim(), passwordController.text.trim());
                  /*unawaited(signUp(
                    emailController: emailController,
                    passwordController: passwordController,
                    passwordTextRepeatInputController:
                        passwordTextRepeatInputController,
                  ).signUpAsync(context, () {
                    if (!mounted) return;
                    context.goNamed('verify_email');
                  }));*/
                },
                child: const Center(
                    child: Text(
                  'Регистрация',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Уже зарегистрированы? ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      context.goNamed('login');
                    },
                    child: const Text(
                      'войти',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
