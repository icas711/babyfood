import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonCacheImage extends StatelessWidget {
  final String imageUrl;
  final bool? isList;
  final double? width, height;
final String? ageOfIntroduce;
final bool? isMini;

  const PersonCacheImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.isList=false,
    this.ageOfIntroduce,
    this.isMini=false,

  }) : super(key: key);

  Widget _imageWidget(ImageProvider imageProvider) {
    return Stack(
      children: [Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: isList!
              ? const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12))
              : const BorderRadius.all(Radius.circular(12)),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
        if(ageOfIntroduce!=null) Positioned(
          top: 10,
          left: 10,
          child: Container(

            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12))
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Text('$ageOfIntroduceм+',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    String newImageUrl=imageUrl.replaceAll('img/babyfood/icons','img/babyfood/icons/mini');
    newImageUrl=newImageUrl.replaceAll('img/babyfood/recipes','img/babyfood/recipes/mini');
    newImageUrl=newImageUrl.replaceAll('.png', 'mini.png');
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: isMini!?'https://babylabpro.ru/$newImageUrl':'https://babylabpro.ru/$imageUrl',
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
