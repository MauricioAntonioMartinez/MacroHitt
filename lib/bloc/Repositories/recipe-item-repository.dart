import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../db/db.dart';
import '../Model/Crud.dart';
import '../Model/model.dart';

class RecipeItemRepository implements CRUD<RecipeItem> {
  final uuid = Uuid();
  Future<RecipeItem> addItem(RecipeItem recipeItem) async {
    final database = await db();
    await database.insert(
      'recipe_meal',
      recipeItem.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return recipeItem;
  }

  Future<void> deleteItem(String mealId, [String recipeId]) async {
    final database = await db();
    database.delete(
      'recipe_meal',
      whereArgs: [mealId, recipeId],
      where: 'meal_id=?  AND recipe_id=?',
    );
  }

  Future<RecipeItem> updateItem(
    RecipeItem recipeItem,
  ) async {
    final database = await db();
    await database.update(
      'recipe_meal',
      recipeItem.toJson(),
      whereArgs: [recipeItem.mealId, recipeItem.recipeId],
      where: 'meal_id=? AND recipe_id=?',
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return recipeItem;
  }

  Future<List<RecipeItem>> findItems() async {}

  Future<RecipeItem> findItem(String id) async {
    final database = await db();
    database.query('recipe_meal', where: 'meal_id=? ');
  }
}
