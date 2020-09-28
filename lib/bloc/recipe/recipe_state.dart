part of 'recipe_bloc.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();
  @override
  List<Object> get props => [];
}

class Recipes extends RecipeState {
  final List<MealItem> recipes;
  Recipes(this.recipes);
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoadSuccess extends RecipeState {
  final Recipe recipe;
  RecipeLoadSuccess(this.recipe);
  @override
  List<Object> get props => [recipe];
}

class RecipeLoadFailure extends RecipeState {
  final String message;
  RecipeLoadFailure(this.message);
}

class RecipeDeleteSuccess extends RecipeState {}

class RecipeSavedSuccess extends RecipeState {}
