import 'package:sqflite/sqflite.dart';
import '../Model/Crud.dart';
import '../Model/Recipie.dart';
import 'package:intl/intl.dart';
import '../../db/db.dart';
import '../Model/model.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

class RecipieRepository implements CRUD<Recipie> {
  final uuid = Uuid();

  Future<Recipie> addItem(Recipie recipie, [String id]) async {
    final database = await db();
    await database.insert(
      'Recipie',
      {
        'id': id,
        'recipieId': recipie.recipieId,
        'protein': 0,
        'carbs': 0,
        'fats': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return Recipie(
        id: id,
        recipieId: recipie.recipieId,
        macrosConsumed: Macro(0, 0, 0),
        meals: []);
  }

  Future<void> deleteItem(String recipieId) async {
    final database = await db();
    await database.delete('Recipie', where: 'id=?', whereArgs: [recipieId]);
  }

  Future<Recipie> updateItem(Recipie recipie, [Macro macro]) async {
    final database = await db();
    await database.update('Recipie',
        {'protein': macro.protein, 'fats': macro.fats, 'carbs': macro.carbs},
        where: 'id=?', whereArgs: [recipie.id]);
    return recipie;
  }

  Future<List<Recipie>> findItems() async {}

  Future<Recipie> findItem(String recipieId, [List<MealItem> userMeals]) async {
    // final date = DateTime.parse(stringDate);
    // final database = await db();
    // final List<Map<String, dynamic>> recipie = await database.query('Recipie');
    // final currentDay = DateFormat.yMMMd().format(date);
    // final RecipieingDay = recipie.firstWhere(
    //     (tr) =>
    //         DateFormat.yMMMd().format(DateTime.parse(tr['date'])) == currentDay,
    //     orElse: () => null);

    // if (RecipieingDay != null) {
    //   final List<Map<String, dynamic>> mealsRecipie = await database.rawQuery(
    //       'SELECT * FROM Recipie_meal A INNER JOIN meal_group B ON A.group_id=B.id  WHERE Recipie_id=?',
    //       [RecipieingDay['id']]);
    //   final Map<MealGroupName, List<MealRecipie>> recipieMeals = [];
    //   mealsRecipie.forEach((meal) {
    //     MealGroupName groupName = dbGrpToGroupName(meal['groupName']);
    //     recipieMeals[groupName] = [
    //       ...(recipieMeals[groupName] != null ? [...recipieMeals[groupName]] : []),
    //       MealRecipie(id: meal['meal_id'], qty: meal['qty'])
    //     ];
    //   });
    //   final meals = Recipie.RecipieMealsToItemMeals(userMeals, RecipieMeals);
    //   return Recipie(
    //       id: RecipieingDay['id'],
    //       date: date,
    //       macrosConsumed: Macro(RecipieingDay['protein'], RecipieingDay['carbs'],
    //           RecipieingDay['fats']),
    //       meals: meals);
    // } else {
    //   return Recipie(
    //       id: '', date: date, macrosConsumed: Macro(0, 0, 0), meals: {});
    // }
  }
}
