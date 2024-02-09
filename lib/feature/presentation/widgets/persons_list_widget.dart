import 'package:babyfood/core/utils/constants.dart';
import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babyfood/feature/presentation/bloc/food_list_cubit/convenience_food_list_cubit.dart';
import 'package:babyfood/feature/presentation/bloc/food_list_cubit/convenience_food_list_state.dart';
import 'package:babyfood/feature/presentation/widgets/food_card_widget.dart';

class PersonsList extends StatelessWidget {
  PersonsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConvenienceFoodListCubit, ConvenienceFoodState>(
        builder: (context, state) {
      List<ConvenienceFoodEntity> foods = [];
      bool isLoading = false;

      if (state is FoodLoading && state.isFirstFetch) {
        return _loadingIndicator();
      } else if (state is FoodLoading) {
        foods = state.oldFoodsList;
        isLoading = true;
      } else if (state is FoodLoaded) {
        foods = state.foodsList;
      } else if (state is FoodError) {
        return Text(
          state.message,
          style: const TextStyle(color: Colors.black87, fontSize: 25),
        );
      }
      Size size = MediaQuery.of(context).size;
      return GridView.builder(
        itemCount: foods.length, // + (isLoading ? 1 : 0),

        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: PersonCard(food: foods[index], isMini: true),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > Routes.smallScreen
              ? (MediaQuery.of(context).size.width > Routes.mediumScreen
                  ? (MediaQuery.of(context).size.width > Routes.largeScreen
                      ? 6
                      : 4)
                  : 3)
              : 2,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          childAspectRatio: 9 / 9,
        ),
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
