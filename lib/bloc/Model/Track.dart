import './model.dart';

enum MealGroupName { BreakFast, Lunch, Dinner, Snack }

class Track extends Macro {
  final String id;
  Map<MealGroupName, List<MealItem>> meals = {};
  Map<MealGroupName, List<MealTrack>> mealsTrack = {};
  final DateTime date;
  Macro macrosConsumed;
  Track({this.id, this.meals, this.date, this.macrosConsumed})
      : super(
            macrosConsumed.protein, macrosConsumed.carbs, macrosConsumed.fats);

  static List<Object> trackMealsToItemMeals(List<MealItem> userMeals,
      Map<MealGroupName, List<MealTrack>> mealsTrack) {
    Map<MealGroupName, List<MealItem>> finalMeals = {};
    var protein = 0.0;
    var carbs = 0.0;
    var fats = 0.0;
    mealsTrack.forEach((key, trackMeals) {
      finalMeals[key] = trackMeals.map((mealTrack) {
        final mealItem = userMeals.firstWhere((m) => m.id == mealTrack.id);
        final qty = mealTrack.qty;
        var origin = MealOrigin.Track;
        if (mealTrack.origin == 'Recipe') origin = MealOrigin.Recipe;
        final carbsMeal = mealItem.carbs * qty;
        final proteinMeal = mealItem.protein * qty;
        final fatsMeal = mealItem.fats * qty;
        protein += proteinMeal;
        carbs += carbsMeal;
        fats += fatsMeal;
        return MealItem(
            id: mealItem.id,
            origin: origin,
            carbs: carbsMeal,
            protein: proteinMeal,
            fats: fatsMeal,
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

    return [finalMeals, Macro(protein, carbs, fats)];
  }

  double get getTotalCalories {
    return this.meals.values.toList().fold(
        0,
        (acc, meals) =>
            acc + 1.1); //meals.fold(0, (acc, meal) => meal.getCalories));
  }

  double get getProtein {
    return this.meals.values.toList().fold(
        0,
        (acc, meal) =>
            acc + 1.1); //meal.fold(0, (acc, meal) => meal.getProtein));
  }

  double get getCarbs {
    return this.meals.values.toList().fold(
        0,
        (acc, meal) =>
            acc + 1.1); //meal.fold(0, (acc, meal) => meal.getCarbs));
  }

  double get getFats {
    return this.meals.values.toList().fold(0,
        (acc, meal) => acc + 1.1); //meal.fold(0, (acc, meal) => meal.getFats));
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'protein': macrosConsumed.protein,
      'carbs': macrosConsumed.carbs,
      'fats': macrosConsumed.fats,
    };
  }
}

class MealTrack {
  final String id;
  final double qty;
  final String origin;
  MealTrack({@required this.id, @required this.qty, @required this.origin});
}
