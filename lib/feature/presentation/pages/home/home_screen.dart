import 'package:babyfood/feature/presentation/pages/home/widget/home_first_screen.dart';
import 'package:babyfood/feature/presentation/widgets/services/auth_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BabyFood: Первый прикорм',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        actions: [
/*          StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {*/
                 IconButton(
                  onPressed: () {
                     context.goNamed('account');},
                    /*if (!snapshot.hasData) {

                      context.goNamed('login');
                    } else {
                      final isEmailVerified =
                          FirebaseAuth.instance.currentUser!.emailVerified;
                      if (!isEmailVerified) context.goNamed('verify_email');
                      context.goNamed('account');
                    }
                  },*/
                  icon: Icon(
                    Icons.person,
                   // color: (!snapshot.hasData) ? Colors.grey : Colors.white,
                  ),
                ),
             // }),
        ],
      ),
      body: Body(),
    );
  }
}
