import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';
import 'package:babyfood/feature/domain/usecases/get_all_foods.dart';
import 'package:babyfood/feature/presentation/bloc/food_list_cubit/convenience_food_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

class ConvenienceFoodListCubit extends Cubit<ConvenienceFoodState> {
  final GetAllFoods getAllFoods;

  ConvenienceFoodListCubit({required this.getAllFoods}) : super(FoodEmpty());

  int page = 1;
void clearProducts() {
  emit(FoodEmpty());
}
  void loadPerson() async {
    debugPrint('State is: $state');
    if (state is FoodLoading) return;
    final currentState = state;


    var oldFood = <ConvenienceFoodEntity>[];
    if (currentState is FoodLoaded) {
      oldFood = currentState.foodsList;
    }

    emit(FoodLoading(oldFood, isFirstFetch: page == 1));

    final failureOrPerson = await getAllFoods!(PageFoodParams(page: page));

    failureOrPerson!.fold(
            (error) => emit(FoodError(message: _mapFailureToMessage(error))),
            (character) {
          page++;
          final foods = (state as FoodLoading).oldFoodsList;
          foods.addAll(character);
          print('List length: ${foods.length.toString()}');
          emit(FoodLoaded(foods));
        });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}