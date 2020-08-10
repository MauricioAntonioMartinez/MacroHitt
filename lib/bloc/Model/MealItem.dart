import './model.dart';

class MealItem extends Macro {
  final String id;
  final String mealName;
  final String servingName;
  final double servingSize;
  final double protein;
  final double carbs;
  final double fats;

  MealItem(
      {@required this.id,
      @required this.mealName,
      @required this.protein,
      @required this.carbs,
      @required this.fats,
      @required this.servingName,
      @required this.servingSize})
      : super(protein, carbs, fats);
}

final myMeal = MealItem(
    carbs: 1,
    fats: 1,
    protein: 1,
    mealName: 'Tilapi',
    id: '1',
    servingName: 'gram',
    servingSize: 1);
