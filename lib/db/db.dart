import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<String> getPaht() async =>
    join(await getDatabasesPath(), 'macro_hitt.db');

Future<Database> db() async {
  return openDatabase(
    await getPaht(),
    onOpen: (db) async {
      //  db.rawQuery('ALTER TABLE goal ADD COLUMN isActive BOOLEAN');
      //print(await db.query('goal'));
      //db.rawQuery('DELETE FROM goal');
      print(await db.query('recipie', where: "id=?", whereArgs: ['2']));
      //print(await db.query('meal_group'));
      // db.rawQuery('DELETE FROM track');

//       db.execute('''

// // INSERT INTO meal_group
// //     (id,groupName)
// // VALUES('2', 'Lunch');

// // INSERT INTO meal_group
// //     (id,groupName)
// // VALUES('3', 'Snack');

// // INSERT INTO meal_group
// //     (id,groupName)
// // VALUES('4', 'Dinner');

// //       ''');
      print('OPEN DATABASE');
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
