import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';
import 'package:babyfood/feature/domain/entities/recipe_entity.dart';
import 'package:babyfood/feature/presentation/bloc/food_list_cubit/convenience_food_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/food_list_cubit/convenience_food_list_state.dart';
import 'package:babyfood/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:babyfood/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:babyfood/feature/presentation/bloc/search_bloc/search_state.dart';
import 'package:babyfood/feature/presentation/pages/recipes/widget/recipe_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipeSearchDelegate extends SearchDelegate {
  RecipeSearchDelegate() : super(searchFieldLabel: 'Поиск рецептов...');

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back_outlined),
        tooltip: 'Back',
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return ShowListFoods(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];


    final List<ConvenienceFoodEntity> foodNames;

    final state =
    BlocProvider.of<ConvenienceFoodListCubit>(context, listen: false).state;
    int maxLengthOfQuery=0;
    if (state is FoodLoaded) {
      foodNames = state.foodsList;
      for (int i = 0; i < foodNames.length; i++) {
        if(maxLengthOfQuery>9) break;
        String food = foodNames[i].name;
        if (food.toLowerCase().contains(query.toLowerCase())) {
          maxLengthOfQuery++;
          matchQuery.add(food);
        }
      }
    }

    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
            onTap: () {
              query = result;
              showResults(context);
              //buildResults(context);
              //ShowListFoods(query: result);
            },
          );
        });
  }
}

class ShowListFoods extends StatelessWidget {
  final String query;

  const ShowListFoods({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Inside custom search delegate and search query is $query');
    BlocProvider.of<RecipeSearchBloc>(context, listen: false)
        .add(SearchRecipes(query));

    return BlocBuilder<RecipeSearchBloc, RecipeSearchState>(
      builder: (context, state) {
        if (state is RecipeSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is RecipeSearchLoaded) {
          final recipe = state.recipes;
          if (recipe.isEmpty) {
            return _showErrorText('Не найдено');
          }
          return GridView.builder(
            itemCount: recipe.isNotEmpty ? recipe.length : 0,
            itemBuilder: (context, int index) {
              RecipeEntity result = recipe[index];
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 8.0),
                  child: RecipeSearchResult(recipeResult: result));
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width >
                      Routes.smallScreen
                  ? (MediaQuery.of(context).size.width > Routes.mediumScreen
                      ? (MediaQuery.of(context).size.width > Routes.largeScreen
                          ? 6
                          : 4)
                      : 3)
                  : 2,
              mainAxisSpacing: 10,
              //mainAxisExtent: 300,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
          );
        } else if (state is RecipeSearchError) {
          return _showErrorText(state.message);
        } else {
          return const Center(
            child: Icon(Icons.now_wallpaper),
          );
        }
      },
    );
  }

  Widget _showErrorText(String errorMessage) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          errorMessage,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
