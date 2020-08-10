part of 'meal_bloc.dart';

@immutable
abstract class MealEvent extends Equatable {
  const MealEvent();
  @override
  List<Object> get props => [];
}

class MealLoad extends MealEvent {}

class MealAdd extends MealEvent {
  final MealItem mealItem;
  const MealAdd(this.mealItem);
  @override
  List<Object> get props => [mealItem];
}

class MealEdit extends MealEvent {
  final MealItem mealItem;
  const MealEdit(this.mealItem);

  @override
  List<Object> get props => [mealItem];
}

class MealRemove extends MealEvent {
  final String id;
  const MealRemove(this.id);

  @override
  List<Object> get props => [id];
}
