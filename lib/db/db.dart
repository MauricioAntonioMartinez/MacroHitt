import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<String> getPaht() async =>
    join(await getDatabasesPath(), 'macro_hitt.db');

Future<Database> db() async {
  return openDatabase(
    await getPaht(),
    onOpen: (db) {
      // db.rawQuery('SELECT * FROM track;').then((value) {
      //   print(value);
      // });
    },
    onCreate: (db, version) {
      return db;
    },
    onUpgrade: (db, oldVerson, newVersion) {
      print('UPDATE');
    },
    version: 15,
  );
}
