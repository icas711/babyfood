import 'package:babyfood/feature/domain/entities/foodnames.dart';

class FoodNameModel extends FoodNameEntity {
  const FoodNameModel({
    required name,
  }) : super(
     name: name,
  );

  factory FoodNameModel.fromJson(var json) {

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
