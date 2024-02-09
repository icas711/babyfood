import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/feature/domain/entities/recipe_entity.dart';
import 'package:dartz/dartz.dart';

abstract class RecipeRepository{
  Future<Either<Failure, List<RecipeEntity>>> getAllRecipes(int start,int end);
  Future<Either<Failure, List<RecipeEntity>>> searchRecipe(String query);
}