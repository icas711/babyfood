import 'package:babyfood/feature/presentation/pages/settings/widgets/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(

        title: const Text('Аккаунт'),

      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(Icons.phone_iphone, size: 100,),
                const SizedBox(
                  height: 50,
                ),
                Text('Добро пожаловать', style: GoogleFonts.oswald(fontSize:35),),
                const LoginWidget(),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
