import 'package:babyfood/feature/domain/entities/foodnames.dart';
import 'package:equatable/equatable.dart';

abstract class FoodNameState extends Equatable {
  const FoodNameState();

  @override
  List<Object> get props => [];
}

class FoodNameEmpty extends FoodNameState {
  @override
  List<Object> get props => [];
}

class FoodNameLoading extends FoodNameState {
  final List<FoodNameEntity> oldPersonsList;
  final bool isFirstFetch;

  const FoodNameLoading(this.oldPersonsList, {this.isFirstFetch = false});

  @override
  List<Object> get props => [oldPersonsList];
}

class FoodNameLoaded extends FoodNameState {
  final List<FoodNameEntity> foodsList;

  const FoodNameLoaded(this.foodsList);

  @override
  List<Object> get props => [foodsList];
}

class FoodNameError extends FoodNameState {
  final String message;

  const FoodNameError({required this.message});

  @override
  List<Object> get props => [message];
}