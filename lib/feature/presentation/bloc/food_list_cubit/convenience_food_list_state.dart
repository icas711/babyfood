import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ConvenienceFoodState extends Equatable {
  const ConvenienceFoodState();

  @override
  List<Object> get props => [];
}

class FoodEmpty extends ConvenienceFoodState {
  @override
  List<Object> get props => [];
}

class FoodLoading extends ConvenienceFoodState {
  final List<ConvenienceFoodEntity> oldFoodsList;
  final bool isFirstFetch;

  const FoodLoading(this.oldFoodsList, {this.isFirstFetch = false});

  @override
  List<Object> get props => [oldFoodsList];
}

class FoodLoaded extends ConvenienceFoodState {
  final List<ConvenienceFoodEntity> foodsList;

  const FoodLoaded(this.foodsList);

  @override
  List<Object> get props => [foodsList];
}

class FoodError extends ConvenienceFoodState {
  final String message;

  const FoodError({required this.message});

  @override
  List<Object> get props => [message];
}