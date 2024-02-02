import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/domain/entities/guides_entity.dart';
import 'package:flutter/material.dart';
import 'package:babyfood/feature/presentation/widgets/food_cache_image_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class GuideCard extends StatelessWidget {
  final GuideEntity guide;
  const GuideCard({
    Key? key,
    required this.guide
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: () {
        context.goNamed(
          'home-detail',
          pathParameters: {
            'guideId': guide.id.toString(),
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
            //color: Colors.white,
            //border: Border.all(
            //  color: Colors.grey.shade300,
           // ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade500,
                offset: const Offset(6, 6),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ]),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 4 / 7,
            child: PersonCacheImage(
              imageUrl: guide.image,

            ),
          ),
        ),
      ),
    );
  }
}
