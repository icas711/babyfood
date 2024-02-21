import 'dart:convert';

import 'package:babyfood/feature/data/datasources/url.dataurls';
import 'package:babyfood/feature/data/models/convenience_food_model.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

initialApp() async {
}


abstract class GetCount {}

class GetCountSql{
  @override
  Future<List<int>> sql(String tableName, SharedPreferences prefs) async {
    int counter=0;
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: hostSql,
        port: portSql,
        user: userSql,
        db: dbSql,
        password: passwordSql));

    var results = await conn.query('select COUNT(*) from $tableName');
    counter = results.first.first;
    final List<String>? babyCache = prefs.getStringList(tableName);
    int counterFromCache = babyCache?.length ?? 0;
    await conn.close();
    return [counterFromCache,counter-counterFromCache];
  }
}

class CheckAbsentId {



  @override
  Future<List<ConvenienceFoodModel>> loadMissed(String tableName, SharedPreferences prefs,List<int> foodsId) async {
    int counter=0;
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: hostSql,
        port: portSql,
        user: userSql,
        db: dbSql,
        password: passwordSql));

    var resultsId = await conn.query('select id from $tableName');
    List<int> missed=[];
    for (var row in resultsId) {
      bool checkin=false;
      foodsId.forEach((element) {
        if(element==row['id']) checkin=true;
      });
      if(!checkin) {missed.add(row['id']);
      print('Missed id: ${row["id"]}');}
    }
    List<ConvenienceFoodModel> m1 = [];
missed.forEach((element) async {
  var results = await conn
      .query('SELECT * FROM babyfood WHERE id = ?', [element]);


  for (var row in results) {
    var results2 = await conn.query(
        "SELECT babyrecipe.name,babyrecipe.id,babyrecipe.image,babyrecipe.ageofIntroduce FROM babyrecipe "
            "JOIN babycrossdata ON babyrecipe.id = babycrossdata.recipe_id "
            "WHERE babycrossdata.food_id = ? "
            "ORDER BY babyrecipe.name REGEXP '^[А-яа-я]' DESC, babyrecipe.name REGEXP '^[A-za-z]' DESC, babyrecipe.name",
        [row['id']]);
    List<ConvenienceFoodListModel> m2 = List.generate(results2.length, (i) => ConvenienceFoodListModel.fromSql(results2.toList()[i]));
    m1.add(ConvenienceFoodModel.fromSql(row, m2));
  }
  // Finally, close the connection
});

    await conn.close();

      final List<String> jsonPersonsList =
      m1.map((person) => json.encode(person.toJson())).toList();
      List<String>? cachedFoods = prefs.getStringList(tableName);
      cachedFoods!.addAll(jsonPersonsList);
cachedFoods.toSet().toList();
      await prefs.setStringList(tableName, cachedFoods);
      debugPrint('Missed Food to write Cache: ${jsonPersonsList.length}');
      return m1;

  }
}

