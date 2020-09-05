part of 'recipie_bloc.dart';

abstract class RecipieState extends Equatable {
  const RecipieState();

  @override
  List<Object> get props => [];
}

class RecipieInitial extends RecipieState {}

class RecipieLoading extends RecipieState {}

class RecipieLoadSuccess extends RecipieState {
  final Recipie recipie;
  RecipieLoadSuccess(this.recipie);
  @override
  List<Object> get props => [recipie];
}

class RecipieLoadFailure extends RecipieState {
  final String message;
  RecipieLoadFailure(this.message);
}

class RecipieDeleteSuccess extends RecipieState {}
