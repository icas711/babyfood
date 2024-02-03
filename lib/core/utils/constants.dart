import 'package:babyfood/common/routes/screens/not_found_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


// Colors that we use in our app
const kPrimaryColor = Color(0xFF0C9869);
const kSelectedColor = Color(0xFF156e50);
const kTextColor = Color(0xFF3C4046);
const kBackgroundColor = Color(0xFFF7F6FC);
const kFontWeight = FontWeight.w700;
const double kDefaultPadding = 20.0;

class Routes{
  static const root = '/';
  static const homeNamedPage = '/home';
  static const homeDetailsNamedPage = 'details';
  static const profileNamedPage = '/profile';
  static const profileDetailsNamedPage = 'details';
  static const settingsNamedPage = '/settings';
  static const smallScreen = 500;
  static const mediumScreen = 700;
  static const largeScreen = 1000;
  static const sizeFonts= 16.0;
  //static profileNamedPage([String? name]) => '/${name ?? ':profile'}';
  static Widget errorWidget(BuildContext context, GoRouterState state) => const NotFoundScreen();


}


