import './model.dart';

class MealTrack {
  final String id;
  final double qty;
  MealTrack({this.id, this.qty});
}

class MealTrackGroup {
  List<MealTrack> meals;
  final String mealGroupName;
  MealTrackGroup({this.meals, this.mealGroupName});

  // void addMeal(MealItem meal) {
  //   MealTrackGroup.add(meal);
  // }

  // void removeMeal(String mealId) {
  //   MealTrackGroup.removeWhere((meal) => meal.id == mealId);
  // }
}

// class Meal {
//   final String mealName;
//   List<MealItem> MealTrackGroupItems = [];

//   double get getCalories {
//     return this.MealTrackGroupItems.fold(0, (acc, meal) => acc + meal.getCalories);
//   }

//   double get getProtein {
//     return this.MealTrackGroupItems.fold(0, (acc, meal) => acc + meal.getProtein);
//   }

//   double get getCarbs {
//     return this.MealTrackGroupItems.fold(0, (acc, meal) => acc + meal.getCarbs);
//   }

//   double get getFats {
//     return this.MealTrackGroupItems.fold(0, (acc, meal) => acc + meal.getFats);
//   }

//   Meal(this.mealName, this.MealTrackGroupItems);
// }
