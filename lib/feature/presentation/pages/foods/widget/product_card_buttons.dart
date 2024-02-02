import 'package:babyfood/feature/domain/entities/recipe_entity.dart';
import 'package:babyfood/feature/presentation/widgets/food_cache_image_widget.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class RecipeCard extends StatelessWidget {
  final RecipeEntity recipe;

  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String ingridientsList = "Состав: ";
    for (int i = 0; i < recipe.food.length; i++) {
      ingridientsList += recipe.food[i].name.toLowerCase();
      if (i != recipe.food.length - 1) {
        ingridientsList += ", ";
      }
    }
    return ZoomTapAnimation(
      onTap: () {
        context.goNamed(
          'recipe-detail',
          pathParameters: {
            'recipeId': recipe.id.toString(),
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade500,
                offset: const Offset(6, 6),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ]),
        child: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: PersonCacheImage(
                          imageUrl: recipe.image,
                          isList: true,
                        ),
                      ),
                    ),
                    Text(
                      recipe.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        ingridientsList,
                        //overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
