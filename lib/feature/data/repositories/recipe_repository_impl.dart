import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/core/platform/network_info.dart';
import 'package:babyfood/feature/data/datasources/recipe_local_datasource.dart';
import 'package:babyfood/feature/data/datasources/recipe_remote_datasource.dart';
import 'package:babyfood/feature/data/models/recipe_model.dart';
import 'package:babyfood/feature/domain/entities/recipe_entity.dart';
import 'package:babyfood/feature/domain/repositories/recipe_repository.dart';

import 'package:dartz/dartz.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  final RecipeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RecipeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  void clearAll() async {
    localDataSource.emptyRecipesInCache();
  }
  @override
  Future<Either<Failure, List<RecipeEntity>>> getAllRecipes(int start,int end) async {
    return await _getRecipes(start, end, () {
      return remoteDataSource.getAllRecipes(start,end);
    });
  }


  @override
  Future<Either<Failure, List<RecipeEntity>>> searchRecipe(String query) async {
    return await _getSearchRecipes(() {
      return remoteDataSource.searchRecipe(query);
    });
  }
  Future<Either<Failure, List<RecipeModel>>> _getSearchRecipes(
      Future<List<RecipeModel>> Function() getRecipes) async {

    if (await networkInfo.isConnected) {
      try {
        final remoteRecipe = await getRecipes();
        localDataSource.recipesSearchToCache(remoteRecipe);
        return Right(remoteRecipe);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localRecipe = await localDataSource.getLastSearchRecipesFromCache();
        return Right(localRecipe);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  Future<Either<Failure, List<RecipeModel>>> _getRecipes(int start,
      int end,
      Future<List<RecipeModel>> Function() getRecipes) async {
    if (end > 0) {
      if (await networkInfo.isConnected) {
        try {
          final remoteRecipe = await getRecipes();
          localDataSource.recipesToCache(remoteRecipe);
          //return Right(remoteFood);
          try {
            final localRecipe = await localDataSource.getLastRecipesFromCache();
            return Right(localRecipe);
          } on CacheException {
            return Left(CacheFailure());
          }
        } on ServerException {
          try {
            final localRecipe = await localDataSource.getLastRecipesFromCache();
            return Right(localRecipe);
          } on CacheException {
            return Left(CacheFailure());
          }
          return Left(ServerFailure());
        }
      }
    } else {
      try {
        final localRecipe = await localDataSource.getLastRecipesFromCache();
        return Right(localRecipe);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
    if (await networkInfo.isConnected) {
      try {
        final remoteRecipe = await getRecipes();
        localDataSource.recipesToCache(remoteRecipe);
        return Right(remoteRecipe);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localRecipe = await localDataSource.getLastRecipesFromCache();
        return Right(localRecipe);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

}
