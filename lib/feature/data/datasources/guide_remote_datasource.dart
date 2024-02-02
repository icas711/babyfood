import 'dart:convert';

import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/feature/data/models/guides_model.dart';
import 'package:http/http.dart' as http;

abstract class GuideRemoteDataSource {
  /// Calls the https://babylabpro.ru/lib/products/?page=1 endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<GuideModel>> getAllGuides(int page);

}

class GuideRemoteDataSourceImpl implements GuideRemoteDataSource {
  final http.Client client;

  GuideRemoteDataSourceImpl({required this.client});

  @override
  Future<List<GuideModel>> getAllGuides(int page) => _getGuideFromUrl(
      'https://babylabpro.ru/lib/guides/');

  Future<List<GuideModel>> _getGuideFromUrl(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final guides = json.decode(response.body);
      return (guides['results'] as List)
          .map((guides) => GuideModel.fromJson(guides))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
