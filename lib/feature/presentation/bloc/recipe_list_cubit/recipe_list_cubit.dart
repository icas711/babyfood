import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/feature/data/datasources/recipe_remote_datasource.dart';
import 'package:babyfood/feature/domain/entities/recipe_entity.dart';
import 'package:babyfood/feature/domain/usecases/get_all_recipes.dart';
import 'package:babyfood/feature/presentation/bloc/recipe_list_cubit/recipe_list_state.dart';
import 'package:babyfood/initaial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

class RecipeListCubit extends Cubit<RecipeState> {
  final GetAllRecipes getAllRecipes;

  RecipeListCubit({required this.getAllRecipes}) : super(RecipeEmpty());

  int page = 1;
  void clearProducts() async {
    emit(RecipeEmpty());
  }
  void loadRecipe() async {
    if (state is RecipeLoading) return;
    final currentState = state;

    final prefs = await SharedPreferences.getInstance();
    List<int> count=[0,0];
    final InternetConnectionChecker connectionChecker=InternetConnectionChecker();
 if(await connectionChecker.hasConnection)
    count = await GetCountSql().sql('babyrecipe', prefs);

    var oldRecipe = <RecipeEntity>[];
    if (currentState is RecipeLoaded) {
      oldRecipe = currentState.recipesList;
    }

    emit(RecipeLoading(oldRecipe));

    final failureOrRecipe = await getAllRecipes!(PageRecipeParams(start: count[0], end: count[1]));
    failureOrRecipe!.fold(
            (error) => emit(RecipeError(message: _mapFailureToMessage(error))),
            (character) async {
          final recipes = (state as RecipeLoading).oldRecipesList;
          recipes.addAll(character);
          List<int> ids = [];
          List<int> doublicates = [];
          recipes.forEach((u) async {
            if (ids.contains(u.id)) {
              doublicates.add(u.id);
            } else
              ids.add(u.id);
          });
          if (doublicates.isNotEmpty) {
            recipes.toSet().toList();
            recipes.addAll(await RecipeRemoteDataSourceImpl().loadMissed('babyrecipe', prefs, ids));
              }
          debugPrint('List recipes length: ${recipes.length.toString()}');
          emit(RecipeLoaded(recipes));
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