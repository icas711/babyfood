import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/core/usecases/usecase.dart';
import 'package:babyfood/feature/domain/entities/recipe_entity.dart';
import 'package:babyfood/feature/domain/repositories/recipe_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SearchRecipe extends UseCase<List<RecipeEntity>, SearchRecipeParams> {
  final RecipeRepository recipeRepository;

  SearchRecipe(this.recipeRepository);

  @override
  Future<Either<Failure, List<RecipeEntity>>> call(
      SearchRecipeParams params) async {
    return await recipeRepository.searchRecipe(params.query);
  }
}

class SearchRecipeParams extends Equatable {
  final String query;

  const SearchRecipeParams({required this.query});

  @override
  List<Object> get props => [query];
}