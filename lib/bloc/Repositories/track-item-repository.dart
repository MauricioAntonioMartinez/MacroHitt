import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../db/db.dart';
import '../Model/Crud.dart';
import '../Model/model.dart';

class TrackItemRepository implements CRUD<MealTrackItem> {
  final uuid = Uuid();
  Future<MealTrackItem> addItem(MealTrackItem trackItem) async {
    final database = await db();
    await database.insert(
      'track_meal',
      trackItem.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return trackItem;
  }

  Future<void> deleteItem(String mealId, [MealTrackItem meal]) async {
    final database = await db();
    database.delete(
      'track_meal',
      whereArgs: [mealId, meal.groupId, meal.trackId],
      where: 'meal_id=? AND group_id=? AND track_id=?',
    );
  }

  Future<MealTrackItem> updateItem(MealTrackItem trackItem,
      [String oldGrpId]) async {
    final database = await db();
    await database.update(
      'track_meal',
      trackItem.toJson(),
      whereArgs: [trackItem.mealId, oldGrpId, trackItem.trackId],
      where: 'meal_id=? AND group_id=? AND track_id=?',
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return trackItem;
  }

  Future<List<MealTrackItem>> findItems() async {}

  Future<MealTrackItem> findItem(String id) async {
    final database = await db();
    database.query('track_meal', where: 'mealId=? ');
  }
}
