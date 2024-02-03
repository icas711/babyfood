import 'package:babyfood/feature/domain/entities/recipe_entity.dart';

class RecipeModel extends RecipeEntity {
  const RecipeModel({
    required id,
    required name,
    required image,
    required yield,
    required ageofIntroduce,
    required cookingTime,
    required recipe,
    required food,
  }) : super(
          id: id,
          name: name,
          image: image,
          yield: yield,
          ageofIntroduce: ageofIntroduce,
          cookingTime: cookingTime,
          recipe: recipe,
          food: food,
        );

  //factory RecipeModel.fromJson(Map<String, dynamic> json) => _$RecipeModelFromJson(json);
 // Map<String, dynamic> toJson() => _$RecipeModelToJson(this);


  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    final originList = json['food'] as List;
    List<FoodModel> foodList =
    originList.map((value) => FoodModel.fromJson(value)).toList();
    return RecipeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      yield: json['yield'] as String,
      ageofIntroduce: json['ageofIntroduce'].toString() as String,
      cookingTime: json['cookingTime'] as String,
      recipe: json['recipe'] as String,
        food: foodList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'yield': yield,
      'ageofIntroduce': ageofIntroduce,
      'cookingTime': cookingTime,
      'recipe': recipe,
      'food': food,
    };
  }
}

class FoodModel extends FoodEntity {
  const FoodModel({
    required id,
    required name,
  }) : super(
          id: id,
          name: name,
        );

//factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
//Map<String, dynamic> toJson() => _$FoodToJson(this);

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
