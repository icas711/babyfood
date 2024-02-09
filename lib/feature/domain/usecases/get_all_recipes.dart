import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/core/usecases/usecase.dart';
import 'package:babyfood/feature/domain/entities/recipe_entity.dart';
import 'package:babyfood/feature/domain/repositories/recipe_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetAllRecipes extends UseCase<List<RecipeEntity>, PageRecipeParams> {
  final RecipeRepository recipeRepository;

  GetAllRecipes(this.recipeRepository);

  @override
  Future<Either<Failure, List<RecipeEntity>>> call(
      PageRecipeParams params) async {
    return await recipeRepository.getAllRecipes(params.start,params.end);
  }
}

class PageRecipeParams extends Equatable {
  final int start;
  final int end;
  PageRecipeParams({required this.start, required this.end});

  @override
  List<Object> get props => [start,end];
}
