import 'package:babyfood/feature/domain/entities/convenience_food_entity.dart';

class ConvenienceFoodModel extends ConvenienceFoodEntity {
  const ConvenienceFoodModel({
    required id,
    required name,
    required image,
    required ageofIntroduce,
    required commonAllergen,
    required nutritionRating,
    required poopFriendly,
    required highChockinHazard,
    required organicIfPossible,
    required howToOffer,
    required characteristics,
    required howToPrepare,
    required durabilityAndStorage,
    required didYouKnow,
    required videos,
    recipes,
  }) : super(
          id: id,
          name: name,
          image: image,
          ageofIntroduce: ageofIntroduce,
          commonAllergen: commonAllergen,
          nutritionRating: nutritionRating,
          poopFriendly: poopFriendly,
          highChockinHazard: highChockinHazard,
          organicIfPossible: organicIfPossible,
          howToOffer: howToOffer,
          characteristics: characteristics,
          howToPrepare: howToPrepare,
          durabilityAndStorage: durabilityAndStorage,
          didYouKnow: didYouKnow,
          videos: videos,
          recipes: recipes,
        );

  factory ConvenienceFoodModel.fromJson(Map<String, dynamic> json) {
    final originList = json['recipes'] as List;
    List<ConvenienceFoodListModel> recipeList = originList
        .map((value) => ConvenienceFoodListModel.fromJson(value))
        .toList();
    return ConvenienceFoodModel(
      id: json['id'] as int,
      name: json['name'] as String,
      ageofIntroduce: json['ageofIntroduce'].toString() as String,
      commonAllergen: json['commonAllergen'] == 0 ? false : true as bool,
      nutritionRating: json['nutritionRating'].toString() as String,
      poopFriendly: json['poopFriendly'] == 0 ? false : true as bool,
      highChockinHazard: json['highChockinHazard'] == 0 ? false : true as bool,
      organicIfPossible: json['organicIfPossible'] == 0 ? false : true as bool,
      howToOffer: json['howToOffer'] as String,
      image: json['image'] as String,
      characteristics: json['characteristics'] as String,
      howToPrepare: json['howToPrepare'] as String,
      durabilityAndStorage: json['durabilityAndStorage'] as String,
      didYouKnow: json['didYouKnow'] as String,
      videos: json['videos'] as String,
      recipes: recipeList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ageofIntroduce': ageofIntroduce,
      'commonAllergen': commonAllergen,
      'nutritionRating': nutritionRating,
      'poopFriendly': poopFriendly,
      'highChockinHazard': highChockinHazard,
      'organicIfPossible': organicIfPossible,
      'howToOffer': howToOffer,
      'image': image,
      'characteristics': characteristics,
      'durabilityAndStorage': durabilityAndStorage,
      'didYouKnow': didYouKnow,
      'howToPrepare': howToPrepare,
      'videos': videos,
      'recipes': recipes,
    };
  }
}

class ConvenienceFoodListModel extends RecipeListEntity {
  const ConvenienceFoodListModel({
    required id,
    required name,
    required image,
    required ageofIntroduce,
  }) : super(
          id: id,
          name: name,
          image: image,
          ageofIntroduce: ageofIntroduce,
        );

  factory ConvenienceFoodListModel.fromJson(Map<String, dynamic> json) {
    return ConvenienceFoodListModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      ageofIntroduce: json['ageofIntroduce'].toString() as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
