import 'package:babyfood/feature/data/models/recipe_model.dart';
import 'package:equatable/equatable.dart';
class RecipeEntity extends Equatable {
  final int id;
  final String name;
  final String image;
  final String yield;
  final String ageofIntroduce;
  final String cookingTime;
  final String recipe;
  final List<FoodModel> food;

  const RecipeEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.yield,
    required this.ageofIntroduce,
    required this.cookingTime,
    required this.recipe,
required this.food,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    image,
    yield,
    ageofIntroduce,
    cookingTime,
    recipe,
    food,
  ];
}

class FoodEntity extends Equatable {
  final int id;
  final String name;

  const FoodEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [
    id,
    name,
  ];
}