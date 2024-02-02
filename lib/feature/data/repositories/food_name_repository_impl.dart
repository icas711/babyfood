import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/core/platform/network_info.dart';
import 'package:babyfood/feature/data/datasources/food_name_local_datasource.dart';
import 'package:babyfood/feature/data/datasources/food_name_remote_datasource.dart';
import 'package:babyfood/feature/data/models/food_name_model.dart';
import 'package:babyfood/feature/domain/entities/foodnames.dart';
import 'package:babyfood/feature/domain/repositories/foodname_repository.dart';
import 'package:dartz/dartz.dart';

class FoodNameRepositoryImpl implements FoodNameRepository {
  final FoodNameRemoteDataSource remoteDataSource;
  final FoodNameLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  FoodNameRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  void clearAll() async {
    localDataSource.emptyFoodNamesInCache();
  }
  @override
  Future<Either<Failure, List<FoodNameEntity>>> getAllFoodNames(int page) async {
    return await _getFoodNames(() {
      return remoteDataSource.getAllFoodNames(page);
    });
  }


  Future<Either<Failure, List<FoodNameModel>>> _getFoodNames(
      Future<List<FoodNameModel>> Function() getFoodNames) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteFoodName = await getFoodNames();
        localDataSource.foodNamesToCache(remoteFoodName);
        return Right(remoteFoodName);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localFoodName = await localDataSource.getLastFoodNameFromCache();
        return Right(localFoodName);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

}
