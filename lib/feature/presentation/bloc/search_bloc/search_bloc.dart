// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/feature/domain/usecases/search_food.dart';
import 'package:babyfood/feature/domain/usecases/search_recipe.dart';
import 'package:babyfood/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:babyfood/feature/presentation/bloc/search_bloc/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

// BLoC 8.0.0
class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchFood searchPerson;

  PersonSearchBloc({required this.searchPerson}) : super(PersonSearchEmpty()) {
    on<SearchPersons>(_onEvent);
  }

  FutureOr<void> _onEvent(
      SearchPersons event, Emitter<PersonSearchState> emit) async {
    emit(PersonSearchLoading());
    final failureOrPerson =
    await searchPerson(SearchPersonParams(query: event.personQuery));
    emit(failureOrPerson.fold(
            (failure) => PersonSearchError(message: _mapFailureToMessage(failure)),
            (person) => PersonSearchLoaded(persons: person)));
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

class RecipeSearchBloc extends Bloc<RecipeSearchEvent, RecipeSearchState> {
  final SearchRecipe searchRecipe;

  RecipeSearchBloc({required this.searchRecipe}) : super(RecipeSearchEmpty()) {
    on<SearchRecipes>(_onEvent);
  }

  FutureOr<void> _onEvent(
      SearchRecipes event, Emitter<RecipeSearchState> emit) async {
    emit(RecipeSearchLoading());
    final failureOrRecipe =
    await searchRecipe(SearchRecipeParams(query: event.recipeQuery));
    emit(failureOrRecipe.fold(
            (failure) => RecipeSearchError(message: _mapFailureToMessage(failure)),
            (recipe) => RecipeSearchLoaded(recipes: recipe)));
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
// BLoC 7.2.0
// class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
//   final SearchPerson searchPerson;

//   PersonSearchBloc({required this.searchPerson}) : super(PersonSearchEmpty());

//   @override
//   Stream<PersonSearchState> mapEventToState(PersonSearchEvent event) async* {
//     if (event is SearchPersons) {
//       yield* _mapFetchPersonsToState(event.personQuery);
//     }
//   }

//   Stream<PersonSearchState> _mapFetchPersonsToState(String personQuery) async* {
//     yield PersonSearchLoading();

//     final failureOrPerson =
//         await searchPerson(SearchPersonParams(query: personQuery));

//     yield failureOrPerson.fold(
//         (failure) => PersonSearchError(message: _mapFailureToMessage(failure)),
//         (person) => PersonSearchLoaded(persons: person));
//   }

// String _mapFailureToMessage(Failure failure) {
//   switch (failure.runtimeType) {
//     case ServerFailure:
//       return SERVER_FAILURE_MESSAGE;
//     case CacheFailure:
//       return CACHED_FAILURE_MESSAGE;
//     default:
//       return 'Unexpected Error';
//   }
// }
// }