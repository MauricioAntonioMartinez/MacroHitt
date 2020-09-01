import 'package:HIIT/bloc/Model/model.dart';
import './Macro.dart';

class Recipie extends Macro {
  final String id;
  final String recipieId;
  List<MealItem> meals = [];
  List<RecipieItem> recipieMeals = [];
  Macro macrosConsumed;

  Recipie({this.id, this.meals, this.recipieId, this.macrosConsumed})
      : super(
            macrosConsumed.protein, macrosConsumed.carbs, macrosConsumed.fats);

  static Map<MealGroupName, List<MealItem>> recipieMealsToItemMeals(
      List<MealItem> userMeals,
      Map<MealGroupName, List<RecipieItem>> recipieMeals) {
    Map<MealGroupName, List<MealItem>> finalMeals = {};
    recipieMeals.forEach((key, trackMeals) {
      finalMeals[key] = trackMeals.map((mealTrack) {
        final mealItem = userMeals.firstWhere((m) => m.id == mealTrack.id);
        final qty = mealTrack.qty;
        return MealItem(
            id: mealItem.id,
            carbs: (mealItem.carbs * qty),
            protein: mealItem.protein * qty,
            fats: mealItem.fats * qty,
            brandName: mealItem.brandName,
            mealName: mealItem.mealName,
            servingName: mealItem.servingName,
            servingSize: mealItem.servingSize * qty,
            monosaturatedFat: mealItem.monosaturatedFat,
            polyunsaturatedFat: mealItem.polyunsaturatedFat,
            saturatedFat: mealItem.saturatedFat,
            sugar: mealItem.sugar,
            fiber: mealItem.fiber);
      }).toList();
    });

    return finalMeals;
  }

  double get getTotalCalories {
    return this.meals.fold(
        0,
        (acc, meals) =>
            acc + 1.1); //meals.fold(0, (acc, meal) => meal.getCalories));
  }

  double get getProtein {
    return this.meals.fold(
        0,
        (acc, meal) =>
            acc + 1.1); //meal.fold(0, (acc, meal) => meal.getProtein));
  }

  double get getCarbs {
    return this.meals.fold(
        0,
        (acc, meal) =>
            acc + 1.1); //meal.fold(0, (acc, meal) => meal.getCarbs));
  }

  double get getFats {
    return this.meals.toList().fold(0,
        (acc, meal) => acc + 1.1); //meal.fold(0, (acc, meal) => meal.getFats));
  }

  Map<String, dynamic> toMap() {
    return {
      'recipieId': recipieId,
      'protein': macrosConsumed.protein,
      'carbs': macrosConsumed.carbs,
      'fats': macrosConsumed.fats,
    };
  }
}
