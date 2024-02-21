import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/core/platform/network_info.dart';
import 'package:babyfood/feature/data/datasources/food_local_datasource.dart';
import 'package:babyfood/feature/data/datasources/food_remote_datasource.dart';
import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';
import 'package:babyfood/feature/domain/repositories/person_repository.dart';
import 'package:dartz/dartz.dart';

class ConvenienceFoodRepositoryImpl implements ConvenienceFoodRepository {
  final ConvenienceFoodRemoteDataSource remoteDataSource;
  final PersonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ConvenienceFoodRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ConvenienceFoodEntity>>> getAllFoods(
      start, end) async {
    if (end > 0) {
      if (await networkInfo.isConnected) {
        try {
          final remoteFood = await remoteDataSource.getAllFoods(start, end);
          await localDataSource.foodsToCache(remoteFood);
        } on ServerException {}
      }
    }
    final dateRenew= await localDataSource.dateOfFoodsRenew();
    final remoteFoodMerge = await remoteDataSource.getAllFoods2(dateRenew);
    await localDataSource.foodsToCacheMerge(remoteFoodMerge);
    final localFood = await localDataSource.getLastPersonsFromCache();
    return Right(localFood);
  }

  @override
  Future<Either<Failure, List<ConvenienceFoodEntity>>> searchFood(
      String query) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteFood = await remoteDataSource.searchFood(query);
        localDataSource.searchFoodsToCache(remoteFood);
        return Right(remoteFood);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localFood = await localDataSource.getLastSearchFoodsFromCache();
        return Right(localFood);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

}
