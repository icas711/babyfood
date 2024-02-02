import 'package:babyfood/common/app_colors.dart';
import 'package:babyfood/feature/presentation/pages/recipes/recipes_page.dart';
import 'package:flutter/material.dart';



class RecipeScreen extends StatelessWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        backgroundColor: AppColors.mainBackground,
        scaffoldBackgroundColor: AppColors.mainBackground,
      ),
      home: RecipesPage(),
    );

  }
}