import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<String> getPaht() async =>
    join(await getDatabasesPath(), 'macro_hitt.db');

Future<Database> db() async {
  return openDatabase(
    await getPaht(),
    onOpen: (db) async {
      print(await db.rawQuery('DELETE FROM track'));
      print(await db.rawQuery('DELETE FROM track_meal'));
      //print(await db.rawQuery('DELETE FROM recipie'));
      //await db.rawQuery('DELETE FROM recipie_meal');
      //await db.rawQuery('DELETE FROM recipie');
      //print(await db.rawQuery('DELETE FROM recipie_meal'));
    },
    onCreate: (db, version) {
      return db;
    },
    onUpgrade: (db, oldVerson, newVersion) {
      print('UPDATE');
    },
    version: 27,
  );
}

//  db.insert('meal_group', {'id': '1', 'groupName': 'BreakFast'},
//           conflictAlgorithm: ConflictAlgorithm.replace);
//       db.insert('meal_group', {'id': '2', 'groupName': 'Lunch'},
//           conflictAlgorithm: ConflictAlgorithm.replace);
//       db.insert('meal_group', {'id': '3', 'groupName': 'Dinner'},
//           conflictAlgorithm: ConflictAlgorithm.replace);
//       db.insert('meal_group', {'id': '4', 'groupName': 'Snack'},
//           conflictAlgorithm: ConflictAlgorithm.replace);
