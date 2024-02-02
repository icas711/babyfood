import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/core/usecases/usecase.dart';
import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';
import 'package:babyfood/feature/domain/repositories/person_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SearchFood extends UseCase<List<ConvenienceFoodEntity>, SearchPersonParams> {
  final ConvenienceFoodRepository personRepository;

  SearchFood(this.personRepository);

  @override
  Future<Either<Failure, List<ConvenienceFoodEntity>>> call(
      SearchPersonParams params) async {
    return await personRepository.searchFood(params.query);
  }
}

class SearchPersonParams extends Equatable {
  final String query;

  const SearchPersonParams({required this.query});

  @override
  List<Object> get props => [query];
}