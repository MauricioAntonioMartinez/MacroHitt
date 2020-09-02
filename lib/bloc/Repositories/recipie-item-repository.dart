import '../Model/model.dart';
import '../../db/db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../Model/Crud.dart';

class RecipieItemRepository implements CRUD<RecipieItem> {
  final uuid = Uuid();
  Future<RecipieItem> addItem(RecipieItem recipieItem) async {
    final database = await db();
    await database.insert(
      'recipie_meal',
      recipieItem.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return recipieItem;
  }

  Future<void> deleteItem(String mealId, [RecipieItem meal]) async {
    final database = await db();
    database.delete(
      'recipie_meal',
      whereArgs: [mealId, meal.recipieId],
      where: 'meal_id=?  AND recipie_id=?',
    );
  }

  Future<RecipieItem> updateItem(
    RecipieItem recipieItem,
  ) async {
    final database = await db();
    await database.update(
      'recipie_meal',
      recipieItem.toJson(),
      whereArgs: [recipieItem.mealId, recipieItem.recipieId],
      where: 'meal_id=? AND recipie_id=?',
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return recipieItem;
  }

  Future<List<RecipieItem>> findItems() async {}

  Future<RecipieItem> findItem(String id) async {
    final database = await db();
    database.query('recipie_meal', where: 'meal_id=? ');
  }
}
