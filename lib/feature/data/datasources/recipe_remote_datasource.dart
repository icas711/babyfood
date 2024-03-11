import 'dart:convert';

import 'package:babyfood/feature/data/datasources/url.dataurls';
import 'package:babyfood/feature/data/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> getAllRecipes(int start,int end);

  Future<List<RecipeModel>> searchRecipe(String query);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final http.Client? client;

  RecipeRemoteDataSourceImpl({this.client});

  @override
  Future<List<RecipeModel>> loadMissed(String tableName, SharedPreferences prefs,List<int> foodsId) async {

    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: hostSql,
        port: portSql,
        user: userSql,
        db: dbSql,
        password: passwordSql));

    final resultsId = await conn.query('select id from $tableName');
    List<int> missed=[];
    for (final row in resultsId) {
      bool checkin=false;
      for (final element in foodsId) {
        if(element==row['id']) checkin=true;
      }
      if(!checkin) {missed.add(row['id']);
      print('Missed id: ${row["id"]}');}
    }
    List<RecipeModel> m1 = [];
    missed.forEach((element) async {
      var results = await conn
          .query('SELECT * FROM $tableName WHERE id = ?', [element]);


      for (var row in results) {
        var results2 = await conn.query(
            "SELECT babyfood.name,babyfood.id FROM babyfood "
                "JOIN babycrossdata ON babyfood.id = babycrossdata.food_id "
                "WHERE babycrossdata.recipe_id = ? "
                "ORDER BY babyfood.name REGEXP '^[А-яа-я]' DESC, babyfood.name REGEXP '^[A-za-z]' DESC, babyfood.name",
            [row['id']]);
        List<FoodModel> m2 = List.generate(results2.length, (i) => FoodModel.fromSql(results2.toList()[i]));
        m1.add(RecipeModel.fromSql(row, m2));
      }
    });

    await conn.close();

    final List<String> jsonPersonsList =
    m1.map((person) => json.encode(person.toJson())).toList();
    List<String>? cachedFoods = prefs.getStringList(tableName);
    cachedFoods!.addAll(jsonPersonsList);
    cachedFoods.toSet().toList();
    await prefs.setStringList(tableName, cachedFoods);
    debugPrint('Missed Recipe to write Cache: ${jsonPersonsList.length}');
    return m1;

  }

  @override
    Future<List<RecipeModel>> getAllRecipes(int start,int end) async {

      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: hostSql,
        port: portSql,
        user: userSql,
        db: dbSql,
        password: passwordSql,
      )
      );
      print('select * from babyrecipe LIMIT $start, $end');
      var results = await conn.query('select * from babyrecipe LIMIT $start, $end');
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
