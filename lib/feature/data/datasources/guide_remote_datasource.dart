import 'dart:convert';

import 'package:babyfood/core/error/exception.dart';
import 'package:babyfood/feature/data/models/guides_model.dart';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';

import 'url.dataurls';

abstract class GuideRemoteDataSource {

  Future<List<GuideModel>> getAllGuides(int page);

}

class GuideRemoteDataSourceImpl implements GuideRemoteDataSource {
  final http.Client client;

  GuideRemoteDataSourceImpl({required this.client});

  @override
  Future<List<GuideModel>> getAllGuides(int page) async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: hostSql,
        port: portSql,
        user: userSql,
        db: dbSql,
        password: passwordSql));

    var results = await conn.query('SELECT * FROM babyguides');
    List<GuideModel> m1 = [];
    for (var row in results) {
      m1.add(GuideModel.fromSql(row));
    }
    // Finally, close the connection
    await conn.close();
    return m1;
  }

}
