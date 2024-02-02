import 'package:babyfood/feature/presentation/widgets/html_cache_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatelessWidget {
  const FullScreenImageViewer(this.url,{Key? key}) : super(key: key);
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Назад')),
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

/*class FullScreenAssetImageViewer extends StatelessWidget {
  final List<String> texts;
  final List<String> urls;
  final int index;
  const FullScreenAssetImageViewer({super.key, required this.urls, required this.texts, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Hero(
            tag: 'imageHero',
            child: GradientImage(url: urls, text: texts,),
            *//*Image.asset(url,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,*//*
            //),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}*/
class FullscreenSlider extends StatelessWidget {
  final List<String> texts;
  final List<String> urls;
  final int index;
  const FullscreenSlider({super.key, required this.urls, required this.texts, required this.index});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Назад')),
      body: Builder(
        builder: (context) {
          final double height = MediaQuery.of(context).size.height;
          return CarouselSlider(
            options: CarouselOptions(
              height: height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              // autoPlay: false,
            ),
            items: urls
                .asMap().map((i, url) => MapEntry(i+index, Container(
              //.map((item) => Container(
              child: Center(
                  child: GradientImage(url: urls[i+index>=texts.length?i+index-texts.length+1:i+index], text: texts[i+index>=texts.length?i+index-texts.length+1:i+index],
                  )),
            ))).values.toList()
          );
        },
      ),
    );
  }
}

class GradientImage extends StatelessWidget {
  Color gradientStart = Colors.transparent;
  Color gradientEnd = Colors.black;
final String url;
final String text;
  GradientImage({super.key, required this.url, required this.text});

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
                    image: ExactAssetImage(url),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Spacer(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 28.0),
                    child: Text(
                     text,
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18.0),
                    constraints: BoxConstraints(
                      maxWidth: 330.0,
                    ),
                  ),
                  flex: 0,
                ),
              ],
            ),
          ]
      ),
    );
  }
}
