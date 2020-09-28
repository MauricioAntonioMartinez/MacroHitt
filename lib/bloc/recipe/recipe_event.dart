part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class LoadRecipes extends RecipeEvent {}

class LoadRecipeMeals extends RecipeEvent {
  final String recipeId;
  LoadRecipeMeals(this.recipeId);
}

class AddEditMealRecipe extends RecipeEvent {
  final MealItem meal;
  AddEditMealRecipe(this.meal);
}

class DeleteMealRecipe extends RecipeEvent {
  final String mealId;
  DeleteMealRecipe(this.mealId);
}

class SaveRecipe extends RecipeEvent {
  final String recipeName;
  SaveRecipe(this.recipeName);
}

class DeleteRecipe extends RecipeEvent {
  final String recipeId;
  DeleteRecipe(this.recipeId);
}

class UpdateRecipeName extends RecipeEvent {
  final String recipeName;
  UpdateRecipeName(this.recipeName);
}
