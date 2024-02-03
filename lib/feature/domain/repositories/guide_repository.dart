import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/feature/domain/entities/guides_entity.dart';
import 'package:dartz/dartz.dart';

abstract class GuideRepository{
  Future<Either<Failure, List<GuideEntity>>> getAllGuides(int page);
}