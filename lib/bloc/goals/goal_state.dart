part of 'goal_bloc.dart';

abstract class GoalState extends Equatable {
  const GoalState();
  @override
  List<Object> get props => [];
}

class GoalSuccess extends GoalState {
  final List<GoalItem> goals;
  final GoalItem activeGoal;
  GoalSuccess(this.goals, this.activeGoal);

  @override
  List<Object> get props => [goals];
}

class GoalLoading extends GoalState {}

class GoalFailure extends GoalState {
  final String message;
  final int statusCode;
  GoalFailure({this.message, this.statusCode});
}
