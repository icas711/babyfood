import 'package:babyfood/feature/presentation/pages/home/widget/home_first_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BabyFood: Первый прикорм',style: TextStyle(fontStyle: FontStyle.italic),)),
      body: Body(),
    );
  }
}
