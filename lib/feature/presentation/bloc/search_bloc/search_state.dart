import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';
import 'package:babyfood/feature/domain/entities/recipe_entity.dart';
import 'package:equatable/equatable.dart';

abstract class PersonSearchState extends Equatable {
  const PersonSearchState();

  @override
  List<Object> get props => [];
}

class PersonSearchEmpty extends PersonSearchState {}

class PersonSearchLoading extends PersonSearchState {}

class PersonSearchLoaded extends PersonSearchState {
  final List<ConvenienceFoodEntity> persons;

  const PersonSearchLoaded({required this.persons});

  @override
  List<Object> get props => [persons];
}

class PersonSearchError extends PersonSearchState {
  final String message;

  const PersonSearchError({required this.message});

  @override
  List<Object> get props => [message];
}

abstract class RecipeSearchState extends Equatable {
  const RecipeSearchState();

  @override
  List<Object> get props => [];
}

class RecipeSearchEmpty extends RecipeSearchState {}

class RecipeSearchLoading extends RecipeSearchState {}

class RecipeSearchLoaded extends RecipeSearchState {
  final List<RecipeEntity> recipes;

  const RecipeSearchLoaded({required this.recipes});

  @override
  List<Object> get props => [recipes];
}

class RecipeSearchError extends RecipeSearchState {
  final String message;

  const RecipeSearchError({required this.message});

  @override
  List<Object> get props => [message];
}