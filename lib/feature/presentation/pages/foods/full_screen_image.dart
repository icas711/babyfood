import 'package:babyfood/feature/presentation/widgets/html_cache_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatelessWidget {
  const FullScreenImageViewer(this.url,{super.key});
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Назад')),
      body: GestureDetector(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
          child: Hero(
            tag: 'imageHero',
            child: HtmlCacheImage(
    imageUrl: url,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
        onTap: () {
        //  Navigator.pop(context);
        },
      ),
    );
  }
}

class FullscreenSlider extends StatelessWidget {
  final List<String> texts;
  final List<String> urls;
  final int index;
  const FullscreenSlider({super.key, required this.urls, required this.texts, required this.index});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Назад')),
      body: Builder(
        builder: (context) {
          final height = MediaQuery.of(context).size.height;
          return CarouselSlider(
            options: CarouselOptions(
              height: height,
              viewportFraction: 1,
            ),
            items: urls
                .asMap().map((i, url) => MapEntry(i+index, Center(
                    child: GradientImage(url: urls[i+index>=texts.length?i+index-texts.length+1:i+index], text: texts[i+index>=texts.length?i+index-texts.length+1:i+index],
                    )))).values.toList()
          );
        },
      ),
    );
  }
}

class GradientImage extends StatefulWidget {
final String url;
final String text;
  const GradientImage({super.key, required this.url, required this.text});

  @override
  State<GradientImage> createState() => _GradientImageState();
}

class _GradientImageState extends State<GradientImage> {
  Color gradientStart = Colors.transparent;

  Color gradientEnd = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
          children: <Widget>[
            ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [gradientStart, gradientEnd],
                ).createShader(Rect.fromLTRB(0, -140, rect.width, rect.height-20));
              },
              blendMode: BlendMode.darken,
              child: Container(
                decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //   colors: [gradientStart, gradientEnd],
                  //   begin: FractionalOffset(0, 0),
                  //   end: FractionalOffset(0, 1),
                  //   stops: [0.0, 1.0],
                  //   tileMode: TileMode.clamp
                  // ),
                  image: DecorationImage(
                    image: ExactAssetImage(widget.url),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                const Spacer(),
                Expanded(
                  flex: 0,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 28),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    constraints: const BoxConstraints(
                      maxWidth: 330,
                    ),
                    child: Text(
                     widget.text,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ]
      ),
    );
  }
}
