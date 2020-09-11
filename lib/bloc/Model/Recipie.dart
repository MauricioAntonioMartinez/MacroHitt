import 'package:HIIT/bloc/Model/model.dart';

import './Macro.dart';

enum RecipieMode { Edit, Create, Add }

class Recipie extends Macro {
  String id;
  String recipeMeal;
  List<MealItem> meals = [];
  List<RecipieItem> recipieMeals = [];
  Macro macrosConsumed;
  double servingSize;

  set setRecipieMeal(String recipieName) {
    this.recipeMeal = recipieName;
  }

  set setId(String id) {
    this.id = id;
  }

  set setServingSize(double qty) {
    this.servingSize = qty;
  }

  Recipie(
      {@required this.id,
      @required this.meals,
      @required this.recipeMeal,
      @required this.macrosConsumed,
      this.servingSize = 1.0})
      : super(
            macrosConsumed.protein, macrosConsumed.carbs, macrosConsumed.fats);

  static List<MealItem> recipieMealsToItemMeals(
      List<MealItem> userMeals, List<RecipieItem> recipieMeals) {
    List<MealItem> myMeals = [];
    recipieMeals.forEach((meal) {
      final mealItem = userMeals.firstWhere((m) => m.id == meal.mealId);
      final qty = meal.qty;
      return myMeals.add(MealItem(
          id: mealItem.id,
          origin: MealOrigin.Recipie,
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
          fiber: mealItem.fiber));
    });

    return myMeals;
  }

  double get getTotalCalories {
    return this.meals.fold(0, (acc, meals) => acc + 1.1);
  }

  double get getProtein {
    return this.meals.fold(0, (acc, meal) => acc + 1.1);
  }

  double get getCarbs {
    return this.meals.fold(0, (acc, meal) => acc + 1.1);
  }

  double get getFats {
    return this.meals.toList().fold(0, (acc, meal) => acc + 1.1);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipieMeal': recipeMeal,
      'protein': macrosConsumed.protein,
      'carbs': macrosConsumed.carbs,
      'fats': macrosConsumed.fats,
    };
  }
}
