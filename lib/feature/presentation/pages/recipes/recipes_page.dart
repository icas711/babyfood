import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/presentation/pages/recipes/widget/recipe_search_delegate.dart';
import 'package:babyfood/feature/presentation/pages/recipes/widget/recipes_list_widget.dart';
import 'package:flutter/material.dart';


class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рецепты', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        shadowColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.search,color: Colors.white,),
            onPressed: () {
              showSearch(context: context, delegate: RecipeSearchDelegate());
            },
          ),
        ],
      ),
      body: RecipesList(),
    );
  }
}