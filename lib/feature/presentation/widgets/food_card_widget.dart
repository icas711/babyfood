import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';
import 'package:flutter/material.dart';
import 'package:babyfood/feature/presentation/widgets/food_cache_image_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class PersonCard extends StatelessWidget {
  final ConvenienceFoodEntity food;
  final bool? isMini;

  const PersonCard({
  Key? key,
    this.isMini,
    required this.food
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: () {
        context.goNamed(
          'product-detail',
          pathParameters: {
            'foodId': food.id.toString(),
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                  imageUrl: food.image,
                  isList: true,
                  ageOfIntroduce: food.ageofIntroduce,
                  isMini: isMini,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                food.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
