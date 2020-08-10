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
