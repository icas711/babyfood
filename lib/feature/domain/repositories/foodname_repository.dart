import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/feature/domain/entities/foodnames.dart';
import 'package:dartz/dartz.dart';

abstract class FoodNameRepository{
  Future<Either<Failure, List<FoodNameEntity>>> getAllFoodNames(int page);
}