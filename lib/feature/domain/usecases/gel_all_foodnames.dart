import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/core/usecases/usecase.dart';
import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';
import 'package:babyfood/feature/domain/entities/foodnames.dart';
import 'package:babyfood/feature/domain/repositories/foodname_repository.dart';
import 'package:babyfood/feature/domain/repositories/person_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetAllFoodNames extends UseCase<List<FoodNameEntity>, PageFoodNameParams> {
  final FoodNameRepository foodNameRepository;

  GetAllFoodNames(this.foodNameRepository);

  @override
  Future<Either<Failure, List<FoodNameEntity>>> call(
      PageFoodNameParams params) async {
    return await foodNameRepository.getAllFoodNames(params.page);
  }
}

class PageFoodNameParams extends Equatable {
  final int page;

  const PageFoodNameParams({required this.page});

  @override
  List<Object> get props => [page];
}
