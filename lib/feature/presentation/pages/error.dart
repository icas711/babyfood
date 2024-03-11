
import 'package:babyfood/core/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ErrorScreen extends StatelessWidget {
  final String textMessage;
  const ErrorScreen({
    required this.textMessage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/error.svg',
              width: 140,
              height: 220,
              fit: BoxFit.cover,
            ),
            Text(
              textMessage,
              style: ThemeText.logo,
            ),
            const SizedBox(height: 24),
            const Text(
              "Извините, ничего не найдено.\n Попробуйте позже.",
              style: ThemeText.progressBody,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}