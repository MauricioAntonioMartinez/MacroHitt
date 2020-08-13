import './model.dart';

class MealItem extends Macro {
  final String id;
  final String mealName;
  final String servingName;
  double servingSize;
  double protein;
  double carbs;
  double fats;

  MealItem(
      {@required this.id,
      @required this.mealName,
      @required this.protein,
      @required this.carbs,
      @required this.fats,
      @required this.servingName,
      @required this.servingSize})
      : super(protein, carbs, fats);

  MealItem updateServingSize(double newQty) {
    final oldServingSize = this.servingSize;
    this.servingSize = newQty;
    this.carbs = (this.carbs / oldServingSize) * newQty;
    this.protein = (this.protein / oldServingSize) * newQty;
    this.fats = (this.fats / oldServingSize) * newQty;
    return this;
  }
}

final myMeal = MealItem(
    carbs: 1,
    fats: 1,
    protein: 1,
    mealName: 'Tilapi',
    id: '1',
    servingName: 'gram',
    servingSize: 1);
