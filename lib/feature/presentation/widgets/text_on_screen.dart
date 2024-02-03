import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/presentation/pages/foods/full_screen_image.dart';
import 'package:babyfood/feature/presentation/widgets/html_cache_image.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:go_router/go_router.dart';

class HtmlTextOnScreen extends StatelessWidget {
  final String data;
  final double width;
  final bool isScreenWide;

  HtmlTextOnScreen(
      {required this.data, required this.width, required this.isScreenWide});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: """
                  $data""",
      onLinkTap: (url, _, __) {
        context.goNamed(
          'product-detail',
          pathParameters: {
            'foodId': url.toString(),
          },
        );
        debugPrint("Opening $url...");
      },
      extensions: [
        ImageExtension(builder: (extensionContext) {
          final element = extensionContext
              .element!.parent!.parent!.children.length; // as ImageElement;
          final element1 = extensionContext.attributes['src'];
          double childImageWidth =
              isScreenWide ? width / (element * 2.4) : width / (element * 1.2);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FullScreenImageViewer(element1!)),
              );
            },
            child: HtmlCacheImage(
              imageUrl: element1!,
              width: childImageWidth,
              height: childImageWidth,
            ),
          );
        }),
        const TableHtmlExtension(),
        OnImageTapExtension(
          onImageTap: (src, imgAttributes, element) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FullScreenImageViewer(src!)),
            );
          },
        ),
      ],
      style: {
        "a": Style(textDecoration: TextDecoration.none),
        "body": Style(fontSize: FontSize(Routes.sizeFonts)),
        "td": Style(
          padding: HtmlPaddings.all(2.0),
          alignment: Alignment.center,
        ),
      },
    );
  }
}

class HtmlTextOnScreenGuides extends StatelessWidget {
  final String data;
  final double width;
  final bool isScreenWide;

  HtmlTextOnScreenGuides(
      {required this.data, required this.width, required this.isScreenWide});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: """
                  $data""",
      onLinkTap: (url, _, __) {
        context.goNamed(
          'recipe-detail',
          pathParameters: {
            'recipeId': url.toString(),
          },
        );
        debugPrint("Opening $url...");
      },
      extensions: [
        ImageExtension(builder: (extensionContext) {
          final element = extensionContext
              .element!.parent!.parent!.children.length; // as ImageElement;
          final element1 = extensionContext.attributes['src'];
          double childImageWidth =
              isScreenWide ? width / (element * 2.4) : width / (element * 1.2);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FullScreenImageViewer(element1!)),
              );
            },
            child: HtmlCacheImage(
              imageUrl: element1!,
              width: childImageWidth,
              height: childImageWidth,
            ),
          );
        }),
        const TableHtmlExtension(),
        OnImageTapExtension(
          onImageTap: (src, imgAttributes, element) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FullScreenImageViewer(src!)),
            );
          },
        ),
      ],
      style: {
        "a": Style(textDecoration: TextDecoration.none),
        "body": Style(fontSize: FontSize(Routes.sizeFonts)),
        "td": Style(
          padding: HtmlPaddings.all(2.0),
          alignment: Alignment.center,
        ),
      },
    );
  }
}
