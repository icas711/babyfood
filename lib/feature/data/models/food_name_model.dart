import 'package:babyfood/feature/domain/entities/foodnames.dart';

class FoodNameModel extends FoodNameEntity {
  const FoodNameModel({
    required name,
  }) : super(
     name: name,
  );

  //factory RecipeModel.fromJson(Map<String, dynamic> json) => _$RecipeModelFromJson(json);
  // Map<String, dynamic> toJson() => _$RecipeModelToJson(this);


  factory FoodNameModel.fromJson(Map<String, dynamic> json) {

    return FoodNameModel(
       name: json['name'] as String,
     );
  }

  Map<String, dynamic> toJson() {
    return {
       'name': name,
     };
  }
}
