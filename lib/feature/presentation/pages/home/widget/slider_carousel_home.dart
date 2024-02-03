import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/presentation/pages/foods/full_screen_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeSliderCarousel extends StatelessWidget {
  HomeSliderCarousel({
    super.key,
  });
  final List<String> imgList = [
    'assets/images/screenshot0.jpg',
    'assets/images/screenshot1.png',
    'assets/images/screenshot2.png',
    'assets/images/screenshot3.png',
    'assets/images/screenshot4.png',
      ];
  final List<String> txtList = [
    'Все что надо знать о прикорме для малышей',
    'В приложении 100+ продуктов и постоянно добавляются',
    'Все тонкости и нюансы подачи блюд для первого прикорма',
    'Можно узнать как нарезать и как подготовить',
    'Множество вкусных, простых и питательных рецептов на любой возраст',
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList
        .map((item) => Image.asset(item, fit: BoxFit.cover))
        .toList();
    return Container(
      width: double.infinity,
        height: 400,
        child: CarouselWithIndicator(imageSliders: imageSliders, imgList: imgList, txtList: txtList,));
  }
}

class CarouselWithIndicator extends StatefulWidget {
  final List<Widget> imageSliders;
  final List<String> imgList;
  final List<String> txtList;

  const CarouselWithIndicator({super.key, required this.imageSliders, required this.imgList, required this.txtList});
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}
class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade100,
        ),
        child: Column(children: [
          Expanded(
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FullscreenSlider(urls:widget.imgList,texts: widget.txtList, index: _current, )),
              );},
              child: CarouselSlider(
                items: widget.imageSliders,
                carouselController: _controller,
                options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    aspectRatio: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.3),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.imgList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                                .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
            Text( widget.txtList[_current], style: const TextStyle(fontWeight: kFontWeight),textAlign: TextAlign.center,),
                const SizedBox(height: kDefaultPadding,)
              ],

            ),
          ),
        ]),
      ),
    );
  }
}
