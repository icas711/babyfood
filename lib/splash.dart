import 'dart:async';

import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/presentation/bloc/food_list_cubit/convenience_food_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/food_list_cubit/convenience_food_list_state.dart';
import 'package:babyfood/feature/presentation/bloc/guide_list_cubit/guide_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/guide_list_cubit/guide_list_state.dart';
import 'package:babyfood/feature/presentation/bloc/recipe_list_cubit/recipe_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/recipe_list_cubit/recipe_list_state.dart';
import 'package:babyfood/routes.dart';
import 'package:babyfood/core/utils/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String loadingString = 'Скачиваем новые продукты...';
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ConvenienceFoodListCubit>(context,listen: true).loadPerson();
    BlocProvider.of<RecipeListCubit>(context,listen: true).loadRecipe();
    BlocProvider.of<GuideListCubit>(context,listen: true).loadGuide();
  }
  @override
  Widget build(BuildContext context) {
      Future.delayed(const Duration(seconds: 15)).then((value) =>
          GoRouter.of(rootNavigatorKey.currentContext!).go('/home')); // !!!
     return BlocBuilder<ConvenienceFoodListCubit, ConvenienceFoodState>(
        builder: (context, state) {
          final stateRecipe =
          BlocProvider.of<RecipeListCubit>(context, listen: false).state;

          final stateGuide =
              BlocProvider.of<GuideListCubit>(context, listen: false).state;

          /*      if (state is FoodLoading) {
            //setState(() {
              loadingString = 'Скачиваем новые продукты...';
            //});
          } else*/
          if (state is FoodLoaded) {
            loadingString = 'Генерируем вкусные рецепты...';
          }
            if (stateRecipe is RecipeLoaded) {
              loadingString = 'Создаем гайды и методички...';
              //GoRouter.of(rootNavigatorKey.currentContext!).go('/home');
            }
            if(stateGuide is GuideLoaded && state is FoodLoaded && stateRecipe is RecipeLoaded){
              GoRouter.of(rootNavigatorKey.currentContext!).go('/home');
            }
          return Scaffold(
              backgroundColor: kPrimaryColor,

              body:
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Column(
                      children: [
                        const Text(
                          'BabyFood\n'
                              'Первый прикорм',
                          style: ThemeText.splashHead,
                          textAlign: TextAlign.center,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SpinKitChasingDots(
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        Text(
                          loadingString,
                          style: ThemeText.progressFooter,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const Text(
                      'powered by Babylabpro\n',
                      textDirection: TextDirection.ltr,
                      style: ThemeText.ercCard,
                    )
                  ],
                ),
              )
          );
        }
    );
  }
}
