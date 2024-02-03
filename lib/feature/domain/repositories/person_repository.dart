import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ConvenienceFoodRepository{
  Future<Either<Failure, List<ConvenienceFoodEntity>>> getAllFoods(int page);
  Future<Either<Failure, List<ConvenienceFoodEntity>>> searchFood(String query);
}