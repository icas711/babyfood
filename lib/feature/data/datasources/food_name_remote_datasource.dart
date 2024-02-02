import 'dart:convert';

import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/feature/data/models/food_name_model.dart';
import 'package:http/http.dart' as http;

abstract class FoodNameRemoteDataSource {
  /// Calls the https://babylabpro.ru/lib/products/?page=1 endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<FoodNameModel>> getAllFoodNames(int page);

}

class FoodNameRemoteDataSourceImpl implements FoodNameRemoteDataSource {
  final http.Client client;

  FoodNameRemoteDataSourceImpl({required this.client});

  @override
  Future<List<FoodNameModel>> getAllFoodNames(int page) => _getPersonFromUrl(
      'https://babylabpro.ru/lib/listnames/');

  Future<List<FoodNameModel>> _getPersonFromUrl(String url) async {
    print(url);
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final persons = json.decode(response.body);
      return (persons['results'] as List)
          .map((person) => FoodNameModel.fromJson(person))
          .toList();
    } else {
      throw ServerException();
    }
  }

}
