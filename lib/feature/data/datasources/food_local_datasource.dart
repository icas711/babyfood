import 'dart:convert';

import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/feature/data/models/convenience_food_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PersonLocalDataSource {
  /// Gets the cached [List<PersonModel>] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.

  Future<List<ConvenienceFoodModel>> getLastPersonsFromCache();
  Future<void> foodsToCache(List<ConvenienceFoodModel> persons);
  void emptyProductsInCache();
}

// ignore: constant_identifier_names
const CACHED_FOOD_LIST = 'CACHED_FOOD_LIST';
const DATE_CACHED_FOOD_LIST = 'DATE_CACHED_FOOD_LIST';

class PersonLocalDataSourceImpl implements PersonLocalDataSource {
  final SharedPreferences sharedPreferences;

  PersonLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ConvenienceFoodModel>> getLastPersonsFromCache() {
      final jsonPersonsList = sharedPreferences.getStringList(
          CACHED_FOOD_LIST);
      //if(jsonPersonsList!=null) {
        if (jsonPersonsList!.isNotEmpty) {
          debugPrint('Get Foods from Cache: ${jsonPersonsList!.length}');
          return Future.value(jsonPersonsList!
              .map((person) => ConvenienceFoodModel.fromJson(json.decode(person!)))
              .toList());
        } else {
          debugPrint('Get Foods from Cache:');
          throw CacheException();
        }

  }

  @override
  Future<List<String>> foodsToCache(List<ConvenienceFoodModel> persons) {
    final List<String> jsonPersonsList =
    persons.map((person) => json.encode(person.toJson())).toList();
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    sharedPreferences.setStringList(CACHED_FOOD_LIST, jsonPersonsList);
    sharedPreferences.setInt(DATE_CACHED_FOOD_LIST, timestamp);
    debugPrint('Persons to write Cache: ${jsonPersonsList.length}');
    return Future.value(jsonPersonsList);
  }
  @override
  void emptyProductsInCache() {
    final List<String> jsonPersonsList = List<String>.empty();
    sharedPreferences.setStringList(CACHED_FOOD_LIST, jsonPersonsList);
    debugPrint('Persons to write Cache: ${jsonPersonsList.length}');

  }
}
