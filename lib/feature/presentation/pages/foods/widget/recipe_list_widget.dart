import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/data/models/convenience_food_model.dart';
import 'package:babyfood/feature/presentation/pages/foods/widget/recipe_card_links_with_product.dart';
import 'package:flutter/material.dart';

class RecipeList extends StatelessWidget {
  final List<ConvenienceFoodListModel> recipe;

  const RecipeList({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: recipe.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index < recipe.length) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              child: RecipeCardLinksWithProduct(
                  recipe: recipe[index], isMini: true),
            );
          }
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: constraints.maxWidth > Routes.smallScreen
              ? (constraints.maxWidth > Routes.mediumScreen
                  ? (constraints.maxWidth > Routes.largeScreen ? 6 : 4)
                  : 3)
              : 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
      );
    }));
  }
}
