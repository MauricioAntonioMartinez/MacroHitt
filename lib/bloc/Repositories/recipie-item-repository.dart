import '../Model/model.dart';
import '../../db/db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../Model/Crud.dart';

class RecipieItemRepository implements CRUD<MealTrackItem> {
  final uuid = Uuid();
  Future<MealTrackItem> addItem(MealTrackItem trackItem) async {
    final database = await db();
    await database.insert(
      'recipie_meal',
      trackItem.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return trackItem;
  }

  Future<void> deleteItem(String mealId, [MealTrackItem meal]) async {
    final database = await db();
    database.delete(
      'recipie_meal',
      whereArgs: [mealId, meal.groupId, meal.trackId],
      where: 'meal_id=? AND group_id=? AND track_id=?',
    );
  }

  Future<MealTrackItem> updateItem(MealTrackItem trackItem,
      [String oldGrpId]) async {
    final database = await db();
    await database.update(
      'recipie_meal',
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
    database.query('recipie_meal', where: 'mealId=? ');
  }
}
