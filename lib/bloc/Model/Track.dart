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

  static Map<MealGroupName, List<MealItem>> trackMealsToItemMeals(
      List<MealItem> userMeals,
      Map<MealGroupName, List<MealTrack>> mealsTrack) {
    Map<MealGroupName, List<MealItem>> finalMeals = {};
    mealsTrack.forEach((key, trackMeals) {
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
  MealTrack({this.id, this.qty});
}

class MealTrackItem {
  final String id;
  final String mealId;
  final String trackId;
  final String groupId;
  final double qty;

  MealTrackItem(this.id, this.mealId, this.trackId, this.groupId, this.qty);

  Map<String, dynamic> toJson() => {
        'id': id,
        'meal_id': mealId,
        'track_id': trackId,
        'group_id': groupId,
        'qty': qty
      };
}
