import 'dart:convert';

import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/feature/data/models/recipe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RecipeLocalDataSource {
  /// Gets the cached [List<PersonModel>] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.

  Future<List<RecipeModel>> getLastRecipesFromCache();
  Future<void> recipesToCache(List<RecipeModel> recipes);
  void emptyRecipesInCache();
}

// ignore: constant_identifier_names
const CACHED_RECIPES_LIST = 'CACHED_RECIPES_LIST';
const DATE_CACHED_RECIPES_LIST = 'DATE_CACHED_RECIPES_LIST';

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  final SharedPreferences sharedPreferences;

  RecipeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<RecipeModel>> getLastRecipesFromCache() {
    final jsonRecipesList = sharedPreferences.getStringList(
        CACHED_RECIPES_LIST);
    //if(jsonPersonsList!=null) {
    if (jsonRecipesList!.isNotEmpty) {
      print('Get Recipes from Cache: ${jsonRecipesList!.length}');
      return Future.value(jsonRecipesList!
          .map((person) => RecipeModel.fromJson(json.decode(person!)))
          .toList());
    } else {
      print('Get Recipes from Cache:');
      throw CacheException();
    }

  }

  @override
  Future<List<String>> recipesToCache(List<RecipeModel> recipes) {
    final List<String> jsonRecipesList =
    recipes.map((recipe) => json.encode(recipe.toJson())).toList();
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    sharedPreferences.setStringList(CACHED_RECIPES_LIST, jsonRecipesList);
    sharedPreferences.setInt(DATE_CACHED_RECIPES_LIST, timestamp);
    print('Recipes to write Cache: ${jsonRecipesList.length}');
    return Future.value(jsonRecipesList);
  }
  @override
  void emptyRecipesInCache() {
    final List<String> jsonRecipesList = List<String>.empty();
    sharedPreferences.setStringList(CACHED_RECIPES_LIST, jsonRecipesList);
    print('Recipes to write Cache: ${jsonRecipesList.length}');

  }
}
