
import 'package:babyfood/feature/data/datasources/url.dataurls';
import 'package:babyfood/feature/data/models/convenience_food_model.dart';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';

abstract class ConvenienceFoodRemoteDataSource {
  Future<List<ConvenienceFoodModel>> getAllFoods(int start,int end);
  Future<List<ConvenienceFoodModel>> getAllFoods2(String date);
  Future<List<ConvenienceFoodModel>> searchFood(String query);

}


class ConvenienceFoodRemoteDataSourceImpl
    implements ConvenienceFoodRemoteDataSource {
  final http.Client client;

  ConvenienceFoodRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ConvenienceFoodModel>> getAllFoods2(String date) async {

    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: hostSql,
      port: portSql,
      user: userSql,
      db: dbSql,
      password: passwordSql,
    )
    );

    var results = await conn.query('select * from babyfood WHERE date> "$date"');
    List<ConvenienceFoodModel> m1 = [];
    for (var row in results) {
      var results2 = await conn.query(
          "SELECT babyrecipe.id,babyrecipe.name,babyrecipe.image,babyrecipe.ageofIntroduce "
              "FROM babyrecipe JOIN babycrossdata ON babyrecipe.id = babycrossdata.recipe_id "
              "WHERE babycrossdata.food_id = ? ORDER BY babyrecipe.name REGEXP '^[А-яа-я]' DESC, babyrecipe.name REGEXP '^[A-za-z]' DESC, babyrecipe.name",
          [row['id']]);
      List<ConvenienceFoodListModel> m2 = List.generate(results2.length, (i) => ConvenienceFoodListModel.fromSql(results2.toList()[i]));
      m1.add(ConvenienceFoodModel.fromSql(row, m2));
    }
    // Finally, close the connection
    await conn.close();
    return m1;
  }
  @override
  Future<List<ConvenienceFoodModel>> getAllFoods(int start,int end) async {

    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: hostSql,
      port: portSql,
      user: userSql,
      db: dbSql,
      password: passwordSql,
    )
    );

    print('select * from babyfood LIMIT $start, $end');
    var results = await conn.query('select * from babyfood LIMIT $start, $end');
    List<ConvenienceFoodModel> m1 = [];
    for (var row in results) {
      var results2 = await conn.query(
          "SELECT babyrecipe.id,babyrecipe.name,babyrecipe.image,babyrecipe.ageofIntroduce "
              "FROM babyrecipe JOIN babycrossdata ON babyrecipe.id = babycrossdata.recipe_id "
              "WHERE babycrossdata.food_id = ? ORDER BY babyrecipe.name REGEXP '^[А-яа-я]' DESC, babyrecipe.name REGEXP '^[A-za-z]' DESC, babyrecipe.name",
          [row['id']]);
      List<ConvenienceFoodListModel> m2 = List.generate(results2.length, (i) => ConvenienceFoodListModel.fromSql(results2.toList()[i]));
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
      List<ConvenienceFoodListModel> m2 = List.generate(results2.length, (i) => ConvenienceFoodListModel.fromSql(results2.toList()[i]));
      m1.add(ConvenienceFoodModel.fromSql(row, m2));
    }
    // Finally, close the connection
    await conn.close();
    return m1;
  }
}
