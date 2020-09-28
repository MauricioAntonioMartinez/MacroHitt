import 'package:HIIT/bloc/Model/model.dart';

enum RecipeMode { Edit, Create, Add }

class Recipe {
  String id;
  String recipeMeal;
  List<MealItem> meals = [];
  List<RecipeItem> recipeMeals = [];
  double servingSize;

  set setRecipeMeal(String recipeName) {
    this.recipeMeal = recipeName;
  }

  set setId(String id) {
    this.id = id;
  }

  set setServingSize(double qty) {
    this.servingSize = qty;
  }

  Recipe(
      {@required this.id,
      @required this.meals,
      @required this.recipeMeal,
      this.servingSize = 1.0});

  static List<MealItem> recipeMealsToItemMeals(
      List<MealItem> userMeals, List<RecipeItem> recipeMeals) {
    List<MealItem> myMeals = [];
    recipeMeals.forEach((meal) {
      final mealItem = userMeals.firstWhere((m) => m.id == meal.mealId);
      final qty = meal.qty;
      return myMeals.add(MealItem(
          id: mealItem.id,
          origin: MealOrigin.Recipe,
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
      'recipeMeal': recipeMeal,
      'protein': getProtein,
      'carbs': getCarbs,
      'fats': getFats,
    };
  }
}
