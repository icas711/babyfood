import 'package:babyfood/common/app_colors.dart';
import 'package:flutter/material.dart';

class PartBoldText extends StatelessWidget {
  final String part1;
  final String part2;

  PartBoldText({required this.part1, required this.part2, String? part3});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14.0,
            color: AppColors.greyColor,
          ),
          children: <TextSpan>[
            TextSpan(
              text: part1,
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: part2,
            ),
          ],
        ),
      ),
    );
  }
}
