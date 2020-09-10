import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../db/db.dart';
import '../Model/Recipie.dart';
import '../Model/model.dart';

class RecipieRepository {
  Future<Recipie> addItem(Recipie recipie) async {
    final database = await db();
    await database.insert(
      'recipie',
      {
        'id': recipie.id,
        'recipieName': recipie.recipeMeal,
        'protein': recipie.protein,
        'carbs': recipie.carbs,
        'fats': recipie.fats,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return Recipie(
        id: recipie.id,
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
          'recipieName': recipie.recipeMeal
        },
        where: 'id=?',
        whereArgs: [recipie.id]);
    return recipie;
  }

  Future<List<MealItem>> findItems() async {
    final database = await db();
    final recipies = await database.query('recipie');

    return recipies.map((r) {
      return MealItem(
          servingName: 'serving',
          brandName: "",
          carbs: r['carbs'],
          fats: r['carbs'],
          protein: r['protein'],
          origin: MealOrigin.Recipie,
          mealName: r['recipieName'],
          id: r['id'],
          servingSize: 1);
    }).toList();
  }

  Future<Recipie> findItem(String recipieId, [List<MealItem> userMeals]) async {
    if (recipieId == null) {
      return Recipie(
          id: '', recipeMeal: '', macrosConsumed: Macro(0, 0, 0), meals: []);
    }

    final database = await db();
    final recipie =
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
    final recipieName = recipie[0]['recipieName'];
    final protein = recipie[0]['protein'];
    final carbs = recipie[0]['carbs'];
    final fats = recipie[0]['fats'];
    final meals = Recipie.recipieMealsToItemMeals(userMeals, recipieMeals);
    return Recipie(
        id: recipieId,
        recipeMeal: recipieName,
        meals: meals,
        macrosConsumed: Macro(protein, carbs, fats));
  }
}
