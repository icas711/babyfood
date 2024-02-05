import 'dart:convert';

import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/feature/data/datasources/url.dataurls';
import 'package:babyfood/feature/data/models/recipe_model.dart';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> getAllRecipes(int page);

  Future<List<RecipeModel>> searchRecipe(String query);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final http.Client client;

  RecipeRemoteDataSourceImpl({required this.client});

  @override
  Future<List<RecipeModel>> getAllRecipes(int page) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: hostSql,
        port: portSql,
        user: userSql,
        db: dbSql,
        password: passwordSql));
    if (conn == null) {
      print('error--------------------------------------');
    }
    var results = await conn.query('select * from babyrecipe');
    List<RecipeModel> m1 = [];
    for (var row in results) {
      var results2 = await conn.query(
          "SELECT babyfood.name,babyfood.id FROM babyfood "
          "JOIN babycrossdata ON babyfood.id = babycrossdata.food_id "
          "WHERE babycrossdata.recipe_id = ? "
          "ORDER BY babyfood.name REGEXP '^[А-яа-я]' DESC, babyfood.name REGEXP '^[A-za-z]' DESC, babyfood.name",
          [row['id']]);
      List<FoodModel> m2 = [];
      for (var row2 in results2) {
        m2.add(FoodModel.fromSql(row2));
      }
      m1.add(RecipeModel.fromSql(row, m2));
    }
    // Finally, close the connection
    await conn.close();
    return m1;
  }

  @override
  Future<List<RecipeModel>> searchRecipe(String query) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: hostSql,
        port: portSql,
        user: userSql,
        db: dbSql,
        password: passwordSql));

    var results = await conn.query(
        "SELECT babyrecipe.* FROM babyrecipe "
        "JOIN babycrossdata ON babycrossdata.recipe_id = babyrecipe.id "
        "JOIN babyfood ON babyfood.id = babycrossdata.food_id "
        "WHERE babyfood.name Like lower(?) ORDER BY babyrecipe.name REGEXP '^[А-яа-я]' DESC, babyrecipe.name REGEXP '^[A-za-z]' DESC, babyrecipe.name",
        ['%$query%']);
    List<RecipeModel> m1 = [];
    for (var row in results) {
      var results2 = await conn.query(
          "SELECT babyfood.name,babyfood.id FROM babyfood "
          "JOIN babycrossdata ON babyfood.id = babycrossdata.food_id "
          "WHERE babycrossdata.recipe_id = ? "
          "ORDER BY babyfood.name REGEXP '^[А-яа-я]' DESC, babyfood.name REGEXP '^[A-za-z]' DESC, babyfood.name",
          [row['id']]);
      List<FoodModel> m2 = [];
      for (var row2 in results2) {
        m2.add(FoodModel.fromSql(row2));
      }
      m1.add(RecipeModel.fromSql(row, m2));
    }
    // Finally, close the connection
    await conn.close();
    return m1;
  }
}
