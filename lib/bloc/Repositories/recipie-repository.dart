import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../db/db.dart';
import '../Model/Crud.dart';
import '../Model/Recipie.dart';
import '../Model/model.dart';

class RecipieRepository implements CRUD<Recipie> {
  Future<Recipie> addItem(Recipie recipie, [String id]) async {
    final database = await db();
    await database.insert(
      'Recipie',
      {
        'id': id,
        'recipieId': recipie.id,
        'recipieMeal': recipie.recipeMeal,
        'protein': recipie.getProtein,
        'carbs': recipie.getCarbs,
        'fats': recipie.getFats,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return Recipie(
        id: id,
        recipeMeal: recipie.recipeMeal,
        macrosConsumed: Macro(0, 0, 0),
        meals: []);
  }

  Future<void> deleteItem(String recipieId) async {
    final database = await db();
    await database
        .delete('recipie_meal', where: 'recipie_id=?', whereArgs: [recipieId]);
    await database.delete('recipie', where: 'id=?', whereArgs: [recipieId]);
  }

  Future<Recipie> updateItem(Recipie recipie, [Macro macro]) async {
    final database = await db();
    await database.update(
        'recipie',
        {
          'protein': macro.protein,
          'fats': macro.fats,
          'carbs': macro.carbs,
          'recipieMeal': recipie.recipeMeal
        },
        where: 'id=?',
        whereArgs: [recipie.id]);
    return recipie;
  }

  Future<List<Recipie>> findItems() async {}

  Future<Recipie> findItem(String recipieId, [List<MealItem> userMeals]) async {
    final database = await db();
    final List<Map<String, dynamic>> recipie =
        await database.query('recipie', where: "id=?", whereArgs: [recipieId]);

    if (recipie.length < 1)
      return Recipie(
          id: '', recipeMeal: '', macrosConsumed: Macro(0, 0, 0), meals: []);

    final List<Map<String, dynamic>> mealsRecipie = await database
        .query('recipie_meal', where: "recipie_id=?", whereArgs: [recipieId]);
    final List<RecipieItem> recipieMeals = [];
    mealsRecipie.forEach((meal) {
      recipieMeals.add(RecipieItem(
          id: meal['id'],
          mealId: meal['meal_id'],
          qty: meal['qty'],
          recipieId: meal['recipie_id']));
    });
    final recipieMeal = recipie[0]['recipieMeal'];
    final meals = Recipie.recipieMealsToItemMeals(userMeals, recipieMeals);
    return Recipie(id: recipieId, recipeMeal: recipieMeal, meals: meals);
  }
}
