import 'package:equatable/equatable.dart';

abstract class PersonSearchEvent extends Equatable {
  const PersonSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchPersons extends PersonSearchEvent {
  final String personQuery;

  const SearchPersons(this.personQuery);


}

abstract class RecipeSearchEvent extends Equatable {
  const RecipeSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchRecipes extends RecipeSearchEvent {
  final String recipeQuery;

  const SearchRecipes(this.recipeQuery);


}