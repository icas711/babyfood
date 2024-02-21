import 'dart:convert';

import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/feature/data/models/recipe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RecipeLocalDataSource {

  Future<List<RecipeModel>> getLastRecipesFromCache();
  Future<void> recipesToCache(List<RecipeModel> recipes);
  void emptyRecipesInCache();
  Future<List<RecipeModel>> getLastSearchRecipesFromCache();
  Future<void> recipesSearchToCache(List<RecipeModel> recipes);
}

// ignore: constant_identifier_names
const CACHED_RECIPES_LIST = 'babyrecipe';
const CACHED_RECIPES_SEARCH_LIST = 'babyrecipe-search';

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  final SharedPreferences sharedPreferences;

  RecipeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<RecipeModel>> getLastRecipesFromCache() {
    final jsonRecipesList = sharedPreferences.getStringList(
        CACHED_RECIPES_LIST)??[];
    //if(jsonPersonsList!=null) {
    if (jsonRecipesList!.isNotEmpty) {
      return Future.value(jsonRecipesList!
          .map((person) => RecipeModel.fromJson(json.decode(person!)))
          .toList());
    } else {
      throw CacheException();
    }

  }

  @override
  Future<List<String>> recipesToCache(List<RecipeModel> recipes) async {
    final List<String> jsonRecipesList =
    recipes.map((recipe) => json.encode(recipe.toJson())).toList();
    List<String> cachedFoods = sharedPreferences.getStringList(CACHED_RECIPES_LIST) ?? [];
    cachedFoods!.addAll(jsonRecipesList);
    await sharedPreferences.setStringList(CACHED_RECIPES_LIST, cachedFoods);
    return Future.value(jsonRecipesList);
  }

  @override
  void emptyRecipesInCache() {
    final List<String> jsonRecipesList = List<String>.empty();
    sharedPreferences.setStringList(CACHED_RECIPES_LIST, jsonRecipesList);

  }

  @override
  Future<List<RecipeModel>> getLastSearchRecipesFromCache() {
    final jsonRecipesList = sharedPreferences.getStringList(
        CACHED_RECIPES_SEARCH_LIST)??[];
    if (jsonRecipesList!.isNotEmpty) {
      return Future.value(jsonRecipesList!
          .map((person) => RecipeModel.fromJson(json.decode(person!)))
          .toList());
    } else {
      throw CacheException();
    }

  }

  @override
  Future<void> recipesSearchToCache(List<RecipeModel> recipes) {
    final List<String> jsonRecipesList =
    recipes.map((recipe) => json.encode(recipe.toJson())).toList();
     sharedPreferences.setStringList(CACHED_RECIPES_SEARCH_LIST, jsonRecipesList);
    return Future.value(jsonRecipesList);
  }
}
