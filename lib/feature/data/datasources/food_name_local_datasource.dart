import 'dart:convert';

import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/feature/data/models/food_name_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FoodNameLocalDataSource {
  /// Gets the cached [List<PersonModel>] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.

  Future<List<FoodNameModel>> getLastFoodNameFromCache();
  Future<void> foodNamesToCache(List<FoodNameModel> foodNames);
  void emptyFoodNamesInCache();
}

// ignore: constant_identifier_names
const CACHED_FOOD_NAMES_LIST = 'CACHED_FOOD_NAMES_LIST';
const DATE_CACHED_FOOD_NAMES_LIST = 'DATE_CACHED_FOOD_NAMES_LIST';

class FoodNameLocalDataSourceImpl implements FoodNameLocalDataSource {
  final SharedPreferences sharedPreferences;

  FoodNameLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<FoodNameModel>> getLastFoodNameFromCache() {
    final jsonPersonsList = sharedPreferences.getStringList(
        CACHED_FOOD_NAMES_LIST);
    //if(jsonPersonsList!=null) {
    if (jsonPersonsList!.isNotEmpty) {
      debugPrint('Get FoodNames from Cache: ${jsonPersonsList!.length}');
      return Future.value(jsonPersonsList!
          .map((person) => FoodNameModel.fromJson(json.decode(person!)))
          .toList());
    } else {
      debugPrint('Get FoodNames from Cache:');
      throw CacheException();
    }

  }

  @override
  Future<List<String>> foodNamesToCache(List<FoodNameModel> persons) {
    final List<String> jsonPersonsList =
    persons.map((person) => json.encode(person.toJson())).toList();
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    sharedPreferences.setStringList(CACHED_FOOD_NAMES_LIST, jsonPersonsList);
    sharedPreferences.setInt(DATE_CACHED_FOOD_NAMES_LIST, timestamp);
    debugPrint('FoodNames to write Cache: ${jsonPersonsList.length}');
    return Future.value(jsonPersonsList);
  }
  @override
  void emptyFoodNamesInCache() {
    final List<String> jsonPersonsList = List<String>.empty();
    sharedPreferences.setStringList(CACHED_FOOD_NAMES_LIST, jsonPersonsList);
    debugPrint('FoodNames to write Cache: ${jsonPersonsList.length}');

  }
}
