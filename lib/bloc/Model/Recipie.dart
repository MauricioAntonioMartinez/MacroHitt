import 'package:HIIT/bloc/Model/model.dart';

enum RecipieMode { Edit, Create, Add }

class Recipie {
  String id;
  String recipeMeal;
  List<MealItem> meals = [];
  List<RecipieItem> recipieMeals = [];
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
      this.servingSize = 1.0});

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
    return this.meals.fold(0, (acc, meal) => acc + meal.getCalories);
  }

  double get getProtein {
    return this.meals.fold(0, (acc, meal) => acc + meal.protein);
  }

  double get getCarbs {
    return this.meals.fold(0, (acc, meal) => acc + meal.carbs);
  }

  double get getFats {
    return this.meals.toList().fold(0, (acc, meal) => acc + meal.fats);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipieMeal': recipeMeal,
      'protein': getProtein,
      'carbs': getCarbs,
      'fats': getFats,
    };
  }
}
