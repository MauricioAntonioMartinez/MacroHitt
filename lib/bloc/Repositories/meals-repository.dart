import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../db/db.dart';
import '../Model/Crud.dart';
import '../Model/model.dart';

class MealItemRepository implements CRUD<MealItem> {
  final uuid = Uuid();
  Future<MealItem> addItem(MealItem mealItem) async {
    final id = uuid.v4();
    final newMeal = mealItem;
    newMeal.setId(id);
    final database = await db();
    await database.insert(
      'mealitem',
      {'id': id, ...newMeal.toMap()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return newMeal;
  }

  Future<void> deleteItem(String mealId) async {
    final database = await db();
    await database.delete(
      'mealitem',
      where: "id = ?",
      whereArgs: [mealId],
    );
    await database
        .delete('track_meal', where: "meal_id=?", whereArgs: [mealId]);
  }

  Future<MealItem> updateItem(MealItem mealItem) async {
    final database = await db();
    await database.update('mealitem', mealItem.toMap(),
        where: 'id=?', whereArgs: [mealItem.id]);
    return mealItem;
  }

  Future<List<MealItem>> findItems() async {
    final database = await db();
    final List<Map<String, dynamic>> fetchMeals =
        await database.query('mealitem');
    List<MealItem> mealsFetched = [];
    fetchMeals.forEach((i) {
      mealsFetched.add(MealItem(
          id: i['id'],
          origin: MealOrigin.Search,
          brandName: i['brandName'],
          mealName: i['mealName'],
          servingName: i['servingName'],
          servingSize: i['servingSize'],
          carbs: i['carbs'],
          fats: i['fats'],
          protein: i['protein'],
          monosaturatedFat: i['monosaturatedFat'],
          polyunsaturatedFat: i['polyunsaturatedFat'],
          saturatedFat: i['saturatedFat'],
          sugar: i['sugar'],
          fiber: i['fiber']));
    });
    return mealsFetched;
  }

  Future<MealItem> findItem(String id) async {
    return MealItem(
        origin: MealOrigin.Search,
        mealName: null,
        protein: null,
        carbs: null,
        fats: null,
        brandName: null,
        servingName: null,
        servingSize: null);
  }
}
