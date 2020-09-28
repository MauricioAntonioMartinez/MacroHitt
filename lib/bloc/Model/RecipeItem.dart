class RecipeItem {
  final String id;
  final String mealId;
  final String recipeId;
  final double qty;

  RecipeItem({this.id, this.mealId, this.recipeId, this.qty});

  Map<String, dynamic> toJson() =>
      {'id': id, 'meal_id': mealId, 'recipe_id': recipeId, 'qty': qty};
}
