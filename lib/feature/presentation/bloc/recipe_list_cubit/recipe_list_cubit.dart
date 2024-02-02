import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/feature/domain/entities/recipe_entity.dart';
import 'package:babyfood/feature/domain/usecases/get_all_recipes.dart';
import 'package:babyfood/feature/presentation/bloc/recipe_list_cubit/recipe_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

class RecipeListCubit extends Cubit<RecipeState> {
  final GetAllRecipes getAllRecipes;

  RecipeListCubit({required this.getAllRecipes}) : super(RecipeEmpty());

  int page = 1;
  void clearProducts() async {
    //emit(PersonLoading(List<PersonEntity>.empty()));
    //emit(PersonLoaded(List<PersonEntity>.empty()));
    emit(RecipeEmpty());
  }
  void loadRecipe() async {
    debugPrint('Recipe State is: $state');
    if (state is RecipeLoading) return;
    final currentState = state;


    var oldRecipe = <RecipeEntity>[];
    if (currentState is RecipeLoaded) {
      oldRecipe = currentState.recipesList;
    }

    emit(RecipeLoading(oldRecipe, isFirstFetch: page == 1));

    final failureOrRecipe = await getAllRecipes!(PageRecipeParams(page: page));

    failureOrRecipe!.fold(
            (error) => emit(RecipeError(message: _mapFailureToMessage(error))),
            (character) {
          page++;
          final recipes = (state as RecipeLoading).oldRecipesList;
          recipes.addAll(character);
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