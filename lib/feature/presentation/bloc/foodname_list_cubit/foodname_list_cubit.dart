import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/feature/domain/entities/foodnames.dart';
import 'package:babyfood/feature/domain/usecases/gel_all_foodnames.dart';
import 'package:babyfood/feature/presentation/bloc/foodname_list_cubit/foodname_list_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

class FoodNameListCubit extends Cubit<FoodNameState> {
  final GetAllFoodNames getAllFoods;

  FoodNameListCubit({required this.getAllFoods}) : super(FoodNameEmpty());

  int page = 1;
  void clearProducts() async {
    emit(FoodNameEmpty());
  }
  void loadFoodName() async {
    debugPrint('FoodName State is: $state');
    if (state is FoodNameLoading) return;
    final currentState = state;


    var oldFoodName = <FoodNameEntity>[];
    if (currentState is FoodNameLoaded) {
      oldFoodName = currentState.foodsList;
    }

    emit(FoodNameLoading(oldFoodName, isFirstFetch: page == 1));

    final failureOrFoodName = await getAllFoods!(PageFoodNameParams(page: page));

    failureOrFoodName!.fold(
            (error) => emit(FoodNameError(message: _mapFailureToMessage(error))),
            (character) {
          page++;
          final foodNames = (state as FoodNameLoading).oldPersonsList;
          foodNames.addAll(character);
          debugPrint('List length of foodNames: ${foodNames.length.toString()}');
          emit(FoodNameLoaded(foodNames));
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