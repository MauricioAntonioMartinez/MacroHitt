part of 'recipie_bloc.dart';

abstract class RecipieEvent extends Equatable {
  const RecipieEvent();

  @override
  List<Object> get props => [];
}

class LoadRecipieMeals extends RecipieEvent {
  final String recipieId;
  LoadRecipieMeals(this.recipieId);
}

class AddEditMealRecipie extends RecipieEvent {
  final MealItem meal;
  AddEditMealRecipie(this.meal);
}

class DeleteMealRecipie extends RecipieEvent {
  final String mealId;
  DeleteMealRecipie(this.mealId);
}

class SaveRecipie extends RecipieEvent {}
