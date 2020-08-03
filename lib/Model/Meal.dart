class Macro {
  final double protein;
  final double carbs;
  final double fats;

  double get getProtein {
    return this.protein * 4;
  }

  double get getCarbs {
    return this.protein * 4;
  }

  double get getFats {
    return this.protein * 9;
  }

  double get getCalories {
    return getProtein + getCarbs + getFats;
  }

  Macro(this.protein, this.carbs, this.fats);
}

class MealItem extends Macro {
  final String mealName;
  final double protein;
  final double carbs;
  final double fats;

  MealItem({this.mealName, this.protein, this.carbs, this.fats})
      : super(protein, carbs, fats);
}

class Meal {
  final String mealName;
  final List<MealItem> mealsItems;

  double get getCalories {
    return this.mealsItems.fold(0, (acc, meal) => acc + meal.getCalories);
  }

  double get getProtein {
    return this.mealsItems.fold(0, (acc, meal) => acc + meal.getProtein);
  }

  double get getCarbs {
    return this.mealsItems.fold(0, (acc, meal) => acc + meal.getCarbs);
  }

  double get getFats {
    return this.mealsItems.fold(0, (acc, meal) => acc + meal.getFats);
  }

  Meal(this.mealName, this.mealsItems);
}

class MacroDay extends Macro {
  final List<Meal> meals;
  final DateTime date;
  final Macro goals;

  double get getTotalCalories {
    return this.meals.fold(0, (acc, meal) => acc + meal.getCalories);
  }

  double get getProtein {
    return this.meals.fold(0, (acc, meal) => acc + meal.getProtein);
  }

  double get getCarbs {
    return this.meals.fold(0, (acc, meal) => acc + meal.getCarbs);
  }

  double get getFats {
    return this.meals.fold(0, (acc, meal) => acc + meal.getFats);
  }

  MacroDay({this.meals,this.date,this.goals}):super(goals.protein,goals.carbs,goals.fats);
}
