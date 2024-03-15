import 'dart:io';

import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/presentation/bloc/food_list_cubit/convenience_food_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/guide_list_cubit/guide_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/recipe_list_cubit/recipe_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:babyfood/initaial.dart';
import 'package:babyfood/locator_service.dart' as di;
import 'package:babyfood/locator_service.dart';
import 'package:babyfood/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initialApp();
  await di.init();
  // turn off the # in the URLs on the web
  //usePathUrlStrategy();

  final countryCode = Platform.localeName.split('_')[1];


    if (countryCode == 'RU') {
      await MobileAds.setUserConsent(true);
      //print(countryCode);
    }

  runApp(
    MultiBlocProvider(providers: [
      BlocProvider<GuideListCubit>(
          lazy: false, create: (context) => sl<GuideListCubit>()..loadGuide()),
      BlocProvider<ConvenienceFoodListCubit>(
          lazy: false,
          create: (context) => sl<ConvenienceFoodListCubit>()..loadPerson()),
      BlocProvider<PersonSearchBloc>(
          create: (context) => sl<PersonSearchBloc>()),
      BlocProvider<RecipeListCubit>(
          lazy: false,
          create: (context) => sl<RecipeListCubit>()..loadRecipe()),
      BlocProvider<RecipeSearchBloc>(
          create: (context) => sl<RecipeSearchBloc>()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  //final _appOpenAdManager = AppOpenAdManager()..loadAppOpenAd();


  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xff49A5C1),
              elevation: 10,
              shadowColor: const Color(0xff49A5C1),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle:
                  const TextStyle(color: Colors.white, fontWeight: kFontWeight),
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(
                  color: kPrimaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            titleTextStyle: TextStyle(
                fontSize: 22, color: Colors.white, fontWeight: FontWeight.w700),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          scaffoldBackgroundColor: kBackgroundColor,
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: Colors.blueGrey.shade100,
            iconTheme: const MaterialStatePropertyAll(IconThemeData(
              color: Colors.black87,
            )),
            labelTextStyle: const MaterialStatePropertyAll(TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            )),
          )),
    );
  }

  @override
  void initState()  {
    super.initState();
    MobileAds.initialize();
  }
}

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 450) {
        return ScaffoldWithNavigationBar(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
      } else {
        return ScaffoldWithNavigationRail(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
      }
    });
  }
}
