import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<String> getPaht() async =>
    join(await getDatabasesPath(), 'macro--hitt.db');

Future<Database> db() async {
  return openDatabase(
    await getPaht(),
    onOpen: (db) async {
      //await db.delete('track_meal');
      //await db.delete('recipe');
      //await db.delete('recipe_meal');
      // await db.rawQuery('DROP TABLE recipe_meal');
      // print(await db.query('recipe_meal'));
      //print(await db.query('track'));
    },
    onCreate: (db, version) async {
      print('CREATE');

      await db.rawQuery('''
      CREATE TABLE mealitem
(
    id TEXT PRIMARY KEY,
    mealName TEXT,
    servingName TEXT,
    brandName TEXT,
    servingSize REAL,
    protein REAL,
    carbs REAL,
    fats REAL,
    sugar REAL,
    fiber REAL,
    saturatedFat REAL,
    monosaturatedFat REAL,
    polyunsaturatedFat REAL
);
      
      ''');
      await db.rawQuery('''
      
      CREATE TABLE track
(
    id TEXT PRIMARY KEY,
    protein REAL,
    carbs REAL,
    fats REAL,
    date TEXT
);
      ''');
      await db.rawQuery('''
      
      

CREATE TABLE meal_group
(
    id TEXT PRIMARY KEY,
    groupName TEXT
);
      ''');
      await db.rawQuery('''

INSERT INTO meal_group
    (id,groupName)
VALUES('1', 'BreakFast');

      ''');
      await db.rawQuery('''
      INSERT INTO meal_group
    (id,groupName)
VALUES('2', 'Lunch');

      ''');
      await db.rawQuery('''

      INSERT INTO meal_group
    (id,groupName)
VALUES('3', 'Dinner');
      ''');
      await db.rawQuery('''
      INSERT INTO meal_group
    (id,groupName)
VALUES('4', 'Snack');

      ''');
      await db.rawQuery('''
      
      
CREATE TABLE track_meal
(
    id TEXT PRIMARY KEY ,
    meal_id TEXT NOT NULL,
    track_id TEXT NOT NULL,
    group_id TEXT NOT NULL,
    origin TEXT NOT NULL,
    qty REAL NOT NULL,
    FOREIGN KEY
(track_id)
       REFERENCES track,
    FOREIGN KEY
(group_id)
       REFERENCES meal_group
(id) ,
    FOREIGN KEY
(meal_id)
       REFERENCES mealitem 
(id) ON DELETE CASCADE
);

      ''');
      await db.rawQuery('''
      CREATE TABLE goal
(
    id TEXT PRIMARY KEY,
    isActive BOOLEAN ,
    goalName TEXT NOT NULL,
    protein REAL,
    carbs REAL,
    fats REAL
);
      
      ''');
      await db.rawQuery('''
      INSERT INTO goal
    (id,isActive,goalName,protein,carbs,fats)
VALUES('1', 1, 'MyGoal', 180, 250, 60);

      ''');
      await db.rawQuery('''
      CREATE TABLE recipe
(
    id TEXT PRIMARY KEY,
    recipeName TEXT,
    protein REAL,
    carbs REAL,
    fats REAL
);

      
      ''');
      await db.rawQuery('''
      
      CREATE TABLE recipe_meal
(
    id TEXT PRIMARY KEY ,
    meal_id TEXT NOT NULL,
    recipe_id TEXT NOT NULL,
    qty REAL NOT NULL,
    FOREIGN KEY
(recipe_id)
       REFERENCES recipe
(id) ON DELETE CASCADE ,
    FOREIGN KEY
(meal_id)
       REFERENCES mealitem 
(id) ON DELETE CASCADE
);
      ''');

      // await db.insert('goal', {
      //   'id': '1',
      //   'isActive': true,
      //   'goalName': 'My Goal',
      //   'protein': 150,
      //   'carbs': 220,
      //   'fats': 50
      // });

      // await db.insert('meal_group', {'id': '1', 'groupName': 'BreakFast'},
      //     conflictAlgorithm: ConflictAlgorithm.replace);
      // await db.insert('meal_group', {'id': '2', 'groupName': 'Lunch'},
      //     conflictAlgorithm: ConflictAlgorithm.replace);
      // await db.insert('meal_group', {'id': '3', 'groupName': 'Dinner'},
      //     conflictAlgorithm: ConflictAlgorithm.replace);
      // await db.insert('meal_group', {'id': '4', 'groupName': 'Snack'},
      //     conflictAlgorithm: ConflictAlgorithm.replace);
      return db;
    },
    onUpgrade: (db, oldVerson, newVersion) {},
    version: 1,
  );
}
