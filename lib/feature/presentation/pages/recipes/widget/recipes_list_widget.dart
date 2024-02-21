import 'dart:async';

import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/domain/entities/recipe_entity.dart';
import 'package:babyfood/feature/presentation/bloc/recipe_list_cubit/recipe_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/recipe_list_cubit/recipe_list_state.dart';
import 'package:babyfood/feature/presentation/pages/recipes/widget/recipe_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RecipesList extends StatelessWidget {
  final scrollController = ScrollController();
  final int page = -1;

  RecipesList({Key? key}) : super(key: key);

  void setupScrollController(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          //BlocProvider.of<PersonListCubit>(context).loadPerson();
          context.read<RecipeListCubit>().loadRecipe();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);

    return BlocBuilder<RecipeListCubit, RecipeState>(builder: (context, state) {
      List<RecipeEntity> recipes = [];
      bool isLoading = false;

      /*if(state is RecipeEmpty)
      {
        isLoading = false;
        context.read<RecipeListCubit>().loadRecipe();
      }*/
      if (state is RecipeLoading && state.isFirstFetch) {
        return _loadingIndicator();
      } else if (state is RecipeLoading) {
        recipes = state.oldRecipesList;
        isLoading = true;
        return _loadingIndicator();
      } else if (state is RecipeLoaded) {
        recipes = state.recipesList;
      } else if (state is RecipeError) {
        return Text(
          state.message,
          style: const TextStyle(color: Colors.black87, fontSize: 25),
        );
      }
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
          return GridView.builder(
            itemCount: recipes.length,

            itemBuilder: (context, index) {
              if (index < recipes.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                  child: RecipeCard(recipe: recipes[index], isMini: true,),
                );
              } else {
                Timer(const Duration(milliseconds: 30), () {
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                });
                return _loadingIndicator();
              }
            },
            //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: constraints.maxWidth > Routes.smallScreen
                  ? (constraints.maxWidth > Routes.mediumScreen
                  ? (constraints.maxWidth > Routes.largeScreen ? 6 : 4)
                  : 3)
                  : 2,
              mainAxisSpacing: 1,
              //mainAxisExtent: 300,
              crossAxisSpacing: 1,
              childAspectRatio: 0.80,
            ),
          );
        }
      );
    });
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
