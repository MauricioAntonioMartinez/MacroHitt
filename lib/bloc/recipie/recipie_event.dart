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

class AddMeal extends RecipieEvent {
  final MealItem meal;
  AddMeal(this.meal);
}

class UpdateMeal extends RecipieEvent {
  final MealItem meal;
  UpdateMeal(this.meal);
}

class DeleteMeal extends RecipieEvent {
  final String mealId;
  DeleteMeal(this.mealId);
}
