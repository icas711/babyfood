import 'package:equatable/equatable.dart';

class ConvenienceFoodEntity extends Equatable {
  final int id;
  final String name;
  final String image;
  final String ageofIntroduce;
  final int commonAllergen;
  final String nutritionRating;
  final int poopFriendly;
  final int highChockinHazard;
  final int organicIfPossible;
  final String howToOffer;
  final String characteristics;
  final String howToPrepare;
  final String durabilityAndStorage;
  final String didYouKnow;
  final String videos;
  final recipes;

  const ConvenienceFoodEntity(
      {required this.id,
      required this.name,
      required this.image,
      required this.ageofIntroduce,
      required this.commonAllergen,
      required this.nutritionRating,
      required this.poopFriendly,
      required this.highChockinHazard,
      required this.organicIfPossible,
      required this.howToOffer,
      required this.characteristics,
      required this.howToPrepare,
      required this.durabilityAndStorage,
      required this.didYouKnow,
      required this.videos,
      this.recipes});

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        ageofIntroduce,
        commonAllergen,
        nutritionRating,
        poopFriendly,
        highChockinHazard,
        organicIfPossible,
        howToOffer,
        characteristics,
        howToPrepare,
        durabilityAndStorage,
        didYouKnow,
        videos,
        recipes,
      ];
}

class RecipeListEntity extends Equatable {
  final int id;
  final String name;
  final String image;
  final String ageofIntroduce;

  const RecipeListEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.ageofIntroduce,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        ageofIntroduce,
      ];
}
