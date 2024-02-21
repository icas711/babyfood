import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';
import 'package:babyfood/feature/domain/usecases/get_all_foods.dart';
import 'package:babyfood/feature/presentation/bloc/food_list_cubit/convenience_food_list_state.dart';
import 'package:babyfood/feature/presentation/bloc/loading_screen_cubit/loading_screen_cubit.dart';
import 'package:babyfood/initaial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    if (state is FoodLoading) return;
    final currentState = state;
    final prefs = await SharedPreferences.getInstance();
    List<int> count=[0,0];
    final InternetConnectionChecker connectionChecker=InternetConnectionChecker();
    if(await connectionChecker.hasConnection)
      count = await GetCountSql().sql('babyfood', prefs);

    var oldFood = <ConvenienceFoodEntity>[];
    if (currentState is FoodLoaded) {
      oldFood = currentState.foodsList;
    }

    emit(FoodLoading(oldFood));
    final failureOrPerson =
        await getAllFoods!(PageFoodParams(start: count[0], end: count[1]));

    failureOrPerson!
        .fold((error) => emit(FoodError(message: _mapFailureToMessage(error))),
            (character) async {
      final foods = (state as FoodLoading).oldFoodsList;
      foods.addAll(character);
      List<int> ids = [];
      List<int> doublicates = [];
      foods.forEach((u) async {
        if (ids.contains(u.id)) {
          doublicates.add(u.id);
        } else
          ids.add(u.id);
      });
      if (doublicates.isNotEmpty) {
        foods.toSet().toList();
        foods.addAll(await CheckAbsentId().loadMissed('babyfood', prefs, ids));
      }
      print('Food length: ${foods.length.toString()}');
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
