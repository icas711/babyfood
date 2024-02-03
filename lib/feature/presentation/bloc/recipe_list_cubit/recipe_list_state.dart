import 'package:babyfood/feature/domain/entities/recipe_entity.dart';
import 'package:equatable/equatable.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

class RecipeEmpty extends RecipeState {
  @override
  List<Object> get props => [];
}

class RecipeLoading extends RecipeState {
  final List<RecipeEntity> oldRecipesList;
  final bool isFirstFetch;

  const RecipeLoading(this.oldRecipesList, {this.isFirstFetch = false});

  @override
  List<Object> get props => [oldRecipesList];
}

class RecipeLoaded extends RecipeState {
  final List<RecipeEntity> recipesList;

  const RecipeLoaded(this.recipesList);

  @override
  List<Object> get props => [recipesList];
}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError({required this.message});

  @override
  List<Object> get props => [message];
}