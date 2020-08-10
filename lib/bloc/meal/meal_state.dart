part of 'meal_bloc.dart';

abstract class MealState extends Equatable {
  const MealState();
  @override
  List<Object> get props => [];
}

class MealLoading extends MealState {}

class MealLoadSuccess extends MealState {
  final List<MealItem> myMeals;
  MealLoadSuccess(this.myMeals);
  @override
  List<Object> get props => [myMeals];
}

class MealLoadFailure extends MealState {
  final String message;
  MealLoadFailure(this.message);
}
