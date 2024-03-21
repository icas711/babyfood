import 'dart:async';

import 'package:babyfood/feature/presentation/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  bool isEmailVerified = false;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider);

    return user.when(
      data: (user) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios, // add custom icons also
            ),
          ),
          title: const Text('Аккаунт'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Open shopping cart',
              onPressed: () => signOut(),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AccountDetails(),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  TextButton(
                    onPressed: () async {
                      await signOut();
                    },
                    child: const Text('Выйти'),
                  ),
                    TextButton(
                      onPressed: () {
                        context.goNamed('edit_account');
                      },
                      child: const Text('Редактировать'),
                    ),
                ],
              ),
              const SizedBox(
                height: 16,
              )
            ],
          ),
        ),
      ),
      error: (e, s) => const Text('error'),
      loading: () => const Text('loading'),
    );
  }
}
