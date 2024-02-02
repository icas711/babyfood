import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';
import 'package:flutter/material.dart';
import 'package:babyfood/feature/presentation/widgets/food_cache_image_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SearchResult extends StatelessWidget {
  final ConvenienceFoodEntity personResult;

  const SearchResult({Key? key, required this.personResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: () {
        context.goNamed(
          'product-detail',
          pathParameters: {
            'foodId': personResult.id.toString(),
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
                  imageUrl: personResult.image,
                  isList: true,
                  isMini: true,
                  ageOfIntroduce: personResult.ageofIntroduce,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              personResult.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
