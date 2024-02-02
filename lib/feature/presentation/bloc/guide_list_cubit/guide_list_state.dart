import 'package:babyfood/feature/domain/entities/guides_entity.dart';
import 'package:equatable/equatable.dart';

abstract class GuideState extends Equatable {
  const GuideState();

  @override
  List<Object> get props => [];
}

class GuideEmpty extends GuideState {
  @override
  List<Object> get props => [];
}

class GuideLoading extends GuideState {
  final List<GuideEntity> oldGuidesList;
  final bool isFirstFetch;

  const GuideLoading(this.oldGuidesList, {this.isFirstFetch = false});

  @override
  List<Object> get props => [oldGuidesList];
}

class GuideLoaded extends GuideState {
  final List<GuideEntity> guidesList;

  const GuideLoaded(this.guidesList);

  @override
  List<Object> get props => [guidesList];
}

class GuideError extends GuideState {
  final String message;

  const GuideError({required this.message});

  @override
  List<Object> get props => [message];
}