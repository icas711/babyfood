import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/core/usecases/usecase.dart';
import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';
import 'package:babyfood/feature/domain/repositories/person_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetAllFoods extends UseCase<List<ConvenienceFoodEntity>, PageFoodParams> {
  final ConvenienceFoodRepository foodRepository;

  GetAllFoods(this.foodRepository);

  @override
  Future<Either<Failure, List<ConvenienceFoodEntity>>> call(
      PageFoodParams params) async {
    return await foodRepository.getAllFoods(params.start,params.end);
  }
}

class PageFoodParams extends Equatable {
  final int start;
  final int end;
  PageFoodParams({required this.start, required this.end});

  @override
  List<Object> get props => [start,end];
}
