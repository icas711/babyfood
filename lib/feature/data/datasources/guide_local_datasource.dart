import 'dart:convert';

import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/feature/data/models/guides_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class GuideLocalDataSource {

  Future<List<GuideModel>> getLastGuideFromCache();
  Future<void> guidesToCache(List<GuideModel> foodNames);
  void emptyGuidesInCache();
}

// ignore: constant_identifier_names
const CACHED_GUIDE_LIST = 'CACHED_GUIDE_LIST';
const DATE_CACHED_GUIDE_LIST = 'DATE_CACHED_GUIDE_LIST';

class GuideLocalDataSourceImpl implements GuideLocalDataSource {
  final SharedPreferences sharedPreferences;

  GuideLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<GuideModel>> getLastGuideFromCache() {
    final jsonGuidesList = sharedPreferences.getStringList(
        CACHED_GUIDE_LIST);
    if (jsonGuidesList!.isNotEmpty) {
      debugPrint('Get Guides from Cache: ${jsonGuidesList!.length}');
      return Future.value(jsonGuidesList!
          .map((guide) => GuideModel.fromJson(json.decode(guide!)))
          .toList());
    } else {
      debugPrint('Get Guides from Cache:');

      throw CacheException();
    }

  }

  @override
  Future<List<String>> guidesToCache(List<GuideModel> guide) {
    final List<String> jsonGuidesList =
    guide.map((guide) => json.encode(guide.toJson())).toList();
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    sharedPreferences.setStringList(CACHED_GUIDE_LIST, jsonGuidesList);
    sharedPreferences.setInt(DATE_CACHED_GUIDE_LIST, timestamp);
    print('Guides to write Cache: ${jsonGuidesList.length}');
    return Future.value(jsonGuidesList);
  }
  @override
  void emptyGuidesInCache() {
    final List<String> jsonPersonsList = List<String>.empty();
    sharedPreferences.setStringList(CACHED_GUIDE_LIST, jsonPersonsList);
    print('Guides to write Cache: ${jsonPersonsList.length}');

  }


}
