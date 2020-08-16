import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<String> getPaht() async =>
    join(await getDatabasesPath(), 'macro_hitt.db');

Future<Database> db() async {
  return openDatabase(
    await getPaht(),
    onCreate: (db, version) {
      print('CREATE');
      return db;
    },
    onUpgrade: (db, oldVerson, newVersion) {
      print('UPDATE');
      db.execute(
        "DROP TABLE  mealitem",
      );
      db.execute(
          "CREATE TABLE mealitem (id TEXT PRIMARY KEY, mealName TEXT, servingName TEXT,brandName TEXT,servingSize REAL, protein REAL,carbs REAL,fats REAL,sugar REAL,fiber REAL,saturatedFat REAL,monosaturatedFat REAL,polyunsaturatedFat REAL)");
    },
    version: 7,
  );
}
