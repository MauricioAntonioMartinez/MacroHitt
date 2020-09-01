part of 'recipie_bloc.dart';

abstract class RecipieState extends Equatable {
  const RecipieState();

  @override
  List<Object> get props => [];
}

class RecipieInitial extends RecipieState {}

class RecipieLoading extends RecipieState {}

class RecipieLoadSuccess extends RecipieState {
  final List<MealItem> recipieMeals;
  final String recipieId;
  RecipieLoadSuccess(this.recipieMeals, this.recipieId);
  @override
  List<Object> get props => [recipieMeals];
}

class RecipieLoadFailure extends RecipieState {
  final String message;
  RecipieLoadFailure(this.message);
}
