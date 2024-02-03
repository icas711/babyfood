import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/presentation/widgets/custom_search_delegate.dart';
import 'package:flutter/material.dart';

class HeaderWithSearchBox extends StatelessWidget {
  final bool isWithSearch;
  final String title;
  final Future<dynamic>? press;
  const HeaderWithSearchBox({    Key? key,
    required this.size,
    required this.isWithSearch, required this.title, this.press,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: kDefaultPadding * 1.0),
      // It will cover 20% of our total height
      height: size.height * 0.15,
      child: Container(
        margin: EdgeInsets.only(bottom: kDefaultPadding),
        padding: const EdgeInsets.only(
          left: kDefaultPadding*2,
          right: kDefaultPadding,
          bottom:  kDefaultPadding/2,
        ),
        height: size.height * 0.15 - 7,
        decoration: const BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(26),
            bottomRight: Radius.circular(26),
          ),
        ),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Spacer(),

            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Image.asset("assets/images/icon3.png"),
            ),
          ],
        ),
      ),
    );
  }
}