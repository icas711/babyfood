import 'package:babyfood/common/app_colors.dart';
import 'package:babyfood/feature/presentation/pages/foods/widget/product_first_screen.dart';
import 'package:flutter/material.dart';



class FoodsScreen extends StatelessWidget {
  const FoodsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        backgroundColor: AppColors.mainBackground,
        scaffoldBackgroundColor: AppColors.mainBackground,
      ),
      home: const FoodsPage(),
    );

  }
}