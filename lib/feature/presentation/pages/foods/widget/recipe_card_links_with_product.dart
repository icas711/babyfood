import 'package:babyfood/feature/data/models/convenience_food_model.dart';
import 'package:babyfood/feature/presentation/widgets/food_cache_image_widget.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class RecipeCardLinksWithProduct extends StatelessWidget {
  final ConvenienceFoodListModel recipe;
  final bool? isMini;

  const RecipeCardLinksWithProduct({Key? key, required this.recipe, this.isMini})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: PersonCacheImage(
                  imageUrl: recipe.image,
                  isMini: isMini,
                  isList: true,
                  ageOfIntroduce: recipe.ageofIntroduce,
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              recipe.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
