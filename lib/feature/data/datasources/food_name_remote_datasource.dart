import 'dart:convert';

import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/feature/data/models/food_name_model.dart';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';

import 'url.dataurls';

abstract class FoodNameRemoteDataSource {

  Future<List<FoodNameModel>> getAllFoodNames();

}

class FoodNameRemoteDataSourceImpl implements FoodNameRemoteDataSource {
  final http.Client client;

  FoodNameRemoteDataSourceImpl({required this.client});

  @override
  Future<List<FoodNameModel>> getAllFoodNames() => _getPersonFromUrl();

  Future<List<FoodNameModel>> _getPersonFromUrl() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: hostSql,
        port: portSql,
        user: userSql,
        db: dbSql,
        password: passwordSql));

    var results = await conn.query('select name from babyfood');
    List<FoodNameModel> m1 = [];
    for (var row in results) {
      m1.add(FoodNameModel.fromJson(row));
    }
    // Finally, close the connection
    await conn.close();
    return m1;

  }

}
