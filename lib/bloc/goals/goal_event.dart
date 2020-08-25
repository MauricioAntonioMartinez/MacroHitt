part of 'goal_bloc.dart';

abstract class GoalEvent extends Equatable {
  const GoalEvent();

  @override
  List<Object> get props => [];
}

class GetGoals extends GoalEvent {}

class ToggleActiveGoal extends GoalEvent {
  final String nextActiveGoalId;
  ToggleActiveGoal(this.nextActiveGoalId);
}

class AddGoal extends GoalEvent {
  final GoalItem goal;
  AddGoal(this.goal);
}

class EditGoal extends GoalEvent {
  final GoalItem goal;
  EditGoal(this.goal);
}

class DeleteGoal extends GoalEvent {
  final String goalId;
  DeleteGoal(this.goalId);
}
