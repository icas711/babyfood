import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/core/platform/network_info.dart';
import 'package:babyfood/feature/data/datasources/food_local_datasource.dart';
import 'package:babyfood/feature/data/datasources/food_remote_datasource.dart';
import 'package:babyfood/feature/data/models/convenience_food_model.dart';
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
  void clearAll() async {
    localDataSource.emptyProductsInCache();
  }
  @override
  Future<Either<Failure, List<ConvenienceFoodEntity>>> getAllFoods(int page) async {
    return await _getFoods(() {
      return remoteDataSource.getAllFoods(page);
    });
  }


  @override
  Future<Either<Failure, List<ConvenienceFoodEntity>>> searchFood(String query) async {
    return await _getFoods(() {
      return remoteDataSource.searchFood(query);
    });
  }

  Future<Either<Failure, List<ConvenienceFoodModel>>> _getFoods(
      Future<List<ConvenienceFoodModel>> Function() getFoods) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteFood = await getFoods();
        localDataSource.foodsToCache(remoteFood);
        return Right(remoteFood);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localFood = await localDataSource.getLastPersonsFromCache();
        return Right(localFood);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

}
