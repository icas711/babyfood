import 'dart:convert';

import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/feature/data/models/convenience_food_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PersonLocalDataSource {
  Future<List<ConvenienceFoodModel>> getLastPersonsFromCache();

  Future<void> foodsToCache(List<ConvenienceFoodModel> persons);

  Future<void> searchFoodsToCache(List<ConvenienceFoodModel> persons);

  Future<List<ConvenienceFoodModel>> getLastSearchFoodsFromCache();
}

// ignore: constant_identifier_names
const CACHED_FOOD_LIST = 'babyfood';
const CACHED_FOOD_SEARCH_LIST = 'babyfood-search';

class PersonLocalDataSourceImpl implements PersonLocalDataSource {
  SharedPreferences sharedPreferences;

  PersonLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ConvenienceFoodModel>> getLastPersonsFromCache() async {
    var jsonPersonsList = sharedPreferences.getStringList(CACHED_FOOD_LIST) ?? [];

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
  Future<List<String>> foodsToCache(List<ConvenienceFoodModel> persons) async {

    final List<String> jsonPersonsList =
        persons.map((person) => json.encode(person.toJson())).toList();
    List<String> cachedFoods = await sharedPreferences.getStringList(CACHED_FOOD_LIST) ?? [];

    cachedFoods!.addAll(jsonPersonsList);

    await sharedPreferences.setStringList(CACHED_FOOD_LIST, cachedFoods);
    debugPrint('Persons to write Cache: ${jsonPersonsList.length}');
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    await sharedPreferences.setInt('DATE_CACHED_FOOD_LIST', timestamp);
    return Future.value(jsonPersonsList);
  }

  @override
  Future<void> searchFoodsToCache(List<ConvenienceFoodModel> persons) {
    final List<String> jsonPersonsList =
    persons.map((person) => json.encode(person.toJson())).toList();
    sharedPreferences.setStringList(CACHED_FOOD_SEARCH_LIST, jsonPersonsList);
    debugPrint('Persons to write Cache: ${jsonPersonsList.length}');
    return Future.value(jsonPersonsList);
  }

  @override
  Future<List<ConvenienceFoodModel>> getLastSearchFoodsFromCache() {
    var jsonPersonsList = sharedPreferences.getStringList(CACHED_FOOD_SEARCH_LIST)??[];

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
}
