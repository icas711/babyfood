import 'dart:convert';

import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/feature/data/models/convenience_food_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class ConvenienceFoodRemoteDataSource {
  /// Calls the https://babylabpro.ru/lib/products/?page=1 endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<ConvenienceFoodModel>> getAllFoods(int page);

  /// Calls the https://babylabpro.ru/lib/products/?name=egg endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<ConvenienceFoodModel>> searchFood(String query);
}

class ConvenienceFoodRemoteDataSourceImpl implements ConvenienceFoodRemoteDataSource {
  final http.Client client;

  ConvenienceFoodRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ConvenienceFoodModel>> getAllFoods(int page) => _getFoodFromUrl(
      'https://babylabpro.ru/lib/products/');

  @override
  Future<List<ConvenienceFoodModel>> searchFood(String query) => _getFoodFromUrl(
      'https://babylabpro.ru/lib/search/?name=$query');

  Future<List<ConvenienceFoodModel>> _getFoodFromUrl(String url) async {
    debugPrint(url);
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final foods = json.decode(response.body);
      return (foods['results'] as List)
          .map((person) => ConvenienceFoodModel.fromJson(person))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
