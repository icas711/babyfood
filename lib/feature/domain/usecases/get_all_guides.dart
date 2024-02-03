import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/core/usecases/usecase.dart';
import 'package:babyfood/feature/domain/entities/guides_entity.dart';
import 'package:babyfood/feature/domain/repositories/guide_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetAllGuides extends UseCase<List<GuideEntity>, PageGuideNameParams> {
  final GuideRepository guideRepository;

  GetAllGuides(this.guideRepository);

  @override
  Future<Either<Failure, List<GuideEntity>>> call(
      PageGuideNameParams params) async {
    return await guideRepository.getAllGuides(params.page);
  }
}

class PageGuideNameParams extends Equatable {
  final int page;

  const PageGuideNameParams({required this.page});

  @override
  List<Object> get props => [page];
}
