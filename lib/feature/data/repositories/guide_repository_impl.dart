import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/core/platform/network_info.dart';
import 'package:babyfood/feature/data/datasources/guide_local_datasource.dart';
import 'package:babyfood/feature/data/datasources/guide_remote_datasource.dart';
import 'package:babyfood/feature/data/models/guides_model.dart';
import 'package:babyfood/feature/domain/entities/guides_entity.dart';
import 'package:babyfood/feature/domain/repositories/guide_repository.dart';
import 'package:dartz/dartz.dart';

class GuideRepositoryImpl implements GuideRepository {
  final GuideRemoteDataSource remoteDataSource;
  final GuideLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  GuideRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  void clearAll() async {
    localDataSource.emptyGuidesInCache();
  }

  @override
  Future<Either<Failure, List<GuideEntity>>> getAllGuides(int page) async {
    return await _getGuides(() {
      return remoteDataSource.getAllGuides(page);
    });
  }

  Future<Either<Failure, List<GuideModel>>> _getGuides(
      Future<List<GuideModel>> Function() getGuides) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteGuide = await getGuides();
        localDataSource.guidesToCache(remoteGuide);
        return Right(remoteGuide);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localGuide = await localDataSource.getLastGuideFromCache();
        return Right(localGuide);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

}
