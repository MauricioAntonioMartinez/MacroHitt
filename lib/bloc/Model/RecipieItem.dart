import './BaseMeal.dart';

class RecipieItem extends BaseMeal {
  final String id;
  final String mealId;
  final String recipieId;
  final double qty;

  RecipieItem(this.id, this.mealId, this.recipieId, this.qty)
      : super(id, mealId, recipieId, qty);

  Map<String, dynamic> toJson() =>
      {'id': id, 'meal_id': mealId, 'recipie_id': recipieId, 'qty': qty};
}
