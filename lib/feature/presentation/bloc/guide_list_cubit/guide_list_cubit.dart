import 'package:babyfood/core/error/failure.dart';
import 'package:babyfood/feature/domain/entities/guides_entity.dart';
import 'package:babyfood/feature/domain/usecases/get_all_guides.dart';
import 'package:babyfood/feature/presentation/bloc/guide_list_cubit/guide_list_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

class GuideListCubit extends Cubit<GuideState> {
  final GetAllGuides getAllGuides;

  GuideListCubit({required this.getAllGuides}) : super(GuideEmpty());

  int page = 1;
  void clearGuides() async {
    emit(GuideEmpty());
  }
  void loadGuide() async {
    debugPrint('FoodName State is: $state');
    if (state is GuideLoading) return;
    final currentState = state;


    var oldFoodName = <GuideEntity>[];
    if (currentState is GuideLoaded) {
      oldFoodName = currentState.guidesList;
    }

    emit(GuideLoading(oldFoodName, isFirstFetch: page == 1));

    final failureOrFoodName = await getAllGuides!(PageGuideNameParams(page: page));

    failureOrFoodName!.fold(
            (error) => emit(GuideError(message: _mapFailureToMessage(error))),
            (character) {
          page++;
          final foodNames = (state as GuideLoading).oldGuidesList;
          foodNames.addAll(character);
          debugPrint('List length of guides: ${foodNames.length.toString()}');
          emit(GuideLoaded(foodNames));
        });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}