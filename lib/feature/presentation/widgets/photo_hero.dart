import 'package:babyfood/feature/presentation/widgets/html_cache_image.dart';
import 'package:flutter/material.dart';

class PhotoHero extends StatelessWidget {
  const PhotoHero({
    super.key,
    required this.photo,
    this.onTap,
    required this.width,
    required this.height,
  });

  final String photo;
  final VoidCallback? onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: HtmlCacheImage(
                imageUrl: photo!,
                width: width,
                height: height,
            ),
          ),
        ),
      ),
    );
  }
}