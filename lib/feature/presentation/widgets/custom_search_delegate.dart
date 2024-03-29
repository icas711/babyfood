import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';
import 'package:babyfood/feature/presentation/bloc/food_list_cubit/convenience_food_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/food_list_cubit/convenience_food_list_state.dart';
import 'package:babyfood/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:babyfood/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:babyfood/feature/presentation/bloc/search_bloc/search_state.dart';
import 'package:babyfood/feature/presentation/pages/error.dart';
import 'package:babyfood/feature/presentation/widgets/search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate() : super(searchFieldLabel: 'Поиск продуктов...');

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
    //BlocProvider.of<FoodNameListCubit>(context, listen: false).getAllFoods;

    final state =
        //BlocProvider.of<FoodNameListCubit>(context, listen: false).state;
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
    BlocProvider.of<PersonSearchBloc>(context, listen: false)
        .add(SearchPersons(query));

    return BlocBuilder<PersonSearchBloc, PersonSearchState>(
      builder: (context, state) {
        if (state is PersonSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PersonSearchLoaded) {
          final food = state.persons;
          if (food.isEmpty) {
            return const ErrorScreen(textMessage: 'Не найдено');
          }
          return GridView.builder(
            itemCount: food.isNotEmpty ? food.length : 0,
            itemBuilder: (context, int index) {
              ConvenienceFoodEntity result = food[index];
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 8.0),
                  child: SearchResult(personResult: result));
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
              childAspectRatio: 10 / 9,
            ),
          );
        } else if (state is PersonSearchError) {
          return ErrorScreen(textMessage:  state.message);
        } else {
          return const Center(
            child: Icon(Icons.now_wallpaper),
          );
        }
      },
    );
  }

}
