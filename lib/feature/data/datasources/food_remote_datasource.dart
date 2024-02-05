import 'dart:collection';
import 'dart:convert';

import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/feature/data/models/convenience_food_model.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';

import 'url.dataurls';

abstract class ConvenienceFoodRemoteDataSource {
  Future<List<ConvenienceFoodModel>> getAllFoods(int page);

  Future<List<ConvenienceFoodModel>> searchFood(String query);
}

class ConvenienceFoodRemoteDataSourceImpl
    implements ConvenienceFoodRemoteDataSource {
  final http.Client client;

  ConvenienceFoodRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ConvenienceFoodModel>> getAllFoods(int page) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: hostSql,
        port: portSql,
        user: userSql,
        db: dbSql,
        password: passwordSql));

    var results = await conn.query('select * from babyfood');
    List<ConvenienceFoodModel> m1 = [];
    for (var row in results) {
      var results2 = await conn.query(
          "SELECT babyrecipe.name,babyrecipe.id,babyrecipe.image,babyrecipe.ageofIntroduce "
          "FROM babyrecipe JOIN babycrossdata ON babyrecipe.id = babycrossdata.recipe_id "
          "WHERE babycrossdata.food_id = ? ORDER BY babyrecipe.name REGEXP '^[А-яа-я]' DESC, babyrecipe.name REGEXP '^[A-za-z]' DESC, babyrecipe.name",
          [row[0]]);
      List<ConvenienceFoodListModel> m2 = [];
      for (var row2 in results2) {
        m2.add(ConvenienceFoodListModel.fromSql(row2));
      }
      m1.add(ConvenienceFoodModel.fromSql(row, m2));
    }
    // Finally, close the connection
    await conn.close();
    return m1;
  }

  @override
  Future<List<ConvenienceFoodModel>> searchFood(String query) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: hostSql,
        port: portSql,
        user: userSql,
        db: dbSql,
        password: passwordSql));

    var results = await conn
        .query('SELECT * FROM babyfood WHERE name like lower(?)', ['%$query%']);

    List<ConvenienceFoodModel> m1 = [];
    for (var row in results) {
      var results2 = await conn.query(
          "SELECT babyrecipe.name,babyrecipe.id,babyrecipe.image,babyrecipe.ageofIntroduce FROM babyrecipe "
          "JOIN babycrossdata ON babyrecipe.id = babycrossdata.recipe_id "
          "WHERE babycrossdata.food_id = ? "
          "ORDER BY babyrecipe.name REGEXP '^[А-яа-я]' DESC, babyrecipe.name REGEXP '^[A-za-z]' DESC, babyrecipe.name",
          [row['id']]);
      List<ConvenienceFoodListModel> m2 = [];
      for (var row2 in results2) {
        m2.add(ConvenienceFoodListModel.fromSql(row2));
      }
      m1.add(ConvenienceFoodModel.fromSql(row, m2));
    }
    // Finally, close the connection
    await conn.close();
    return m1;
  }
}
