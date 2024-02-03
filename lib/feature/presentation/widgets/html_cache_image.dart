import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HtmlCacheImage extends StatelessWidget {
  final String imageUrl;
  final double? width, height;

  const HtmlCacheImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
  }) : super(key: key);

  Widget _imageWidget(ImageProvider imageProvider) {
    return  Container(
    width: width,
    height: height,
    foregroundDecoration: BoxDecoration(

      borderRadius: const BorderRadius.all(Radius.circular(12)),
      image: DecorationImage(

        image: imageProvider,
        fit: BoxFit.contain,
      ),
    ),

            );
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        return _imageWidget(imageProvider);
      },
      placeholder: (context, url) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      errorWidget: (context, url, error) {
        return _imageWidget(
          const AssetImage('assets/images/noimage.jpg'),
        );
      },
    );
  }
}