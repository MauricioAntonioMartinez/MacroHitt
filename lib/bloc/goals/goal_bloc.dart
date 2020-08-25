import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../Repositories/goals-repository.dart';
import '../Model/model.dart';

part 'goal_event.dart';
part 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final GoalItemRepository goalsRepository;
  GoalBloc({this.goalsRepository}) : super(GoalLoading()) {
    add(GetGoals());
  }

  @override
  Stream<GoalState> mapEventToState(
    GoalEvent event,
  ) async* {
    if (event is GetGoals) {
      yield* _getGoals(event);
    } else if (event is AddGoal) {
      yield* _addGoal(event);
    } else if (event is EditGoal) {
      yield* _editGoal(event);
    } else if (event is DeleteGoal) {
      yield* _deleteGoal(event);
    } else if (event is ToggleActiveGoal) {
      yield* _toggleActive(event);
    }
  }

  Stream<GoalState> _toggleActive(ToggleActiveGoal event) async* {
    final goals = (state as GoalSuccess).goals;
    final activeGoal = (state as GoalSuccess).activeGoal;
    yield GoalLoading();
    try {
      final nextActiveGoalId = event.nextActiveGoalId;
      await goalsRepository.setActiveGoal(activeGoal.id, nextActiveGoalId);
      final newGoalIndex = goals.indexWhere(
        (goal) => goal.id == nextActiveGoalId,
      );
      final prevGoalIndex = goals.indexWhere(
        (goal) => goal.id == activeGoal.id,
      );

      goals[newGoalIndex].isActive = 1;
      goals[prevGoalIndex].isActive = null;

      yield GoalSuccess(goals, goals[newGoalIndex]);
    } catch (e) {
      yield GoalFailure();
    }
  }

  Stream<GoalState> _getGoals(GetGoals event) async* {
    yield GoalLoading();
    try {
      final goals = await goalsRepository.findItems();
      final goalActive = goals.firstWhere((goal) => goal.isActive == 1,
          orElse: () => goals[0]);

      yield GoalSuccess(goals, goalActive);
    } catch (e) {
      yield GoalFailure(message: 'CANNOT LOAD GOALS', statusCode: 403);
    }
  }

  Stream<GoalState> _addGoal(AddGoal event) async* {
    final goals = (state as GoalSuccess).goals;
    final activeGoal = (state as GoalSuccess).activeGoal;
    yield GoalLoading();
    try {
      await goalsRepository.addItem(event.goal);
      goals.add(event.goal);
      yield GoalSuccess(goals, activeGoal);
    } catch (e) {
      yield GoalFailure(message: 'CANNOT ADD GOAL', statusCode: 304);
    }
  }

  Stream<GoalState> _editGoal(EditGoal event) async* {
    final goals = (state as GoalSuccess).goals;
    final activeGoal = (state as GoalSuccess).activeGoal;
    yield GoalLoading();
    try {
      final editedGoal = event.goal;
      await goalsRepository.updateItem(editedGoal);
      final indexGoal = goals.indexWhere((gl) => gl.id == editedGoal.id);
      goals[indexGoal] = editedGoal;
      yield GoalSuccess(goals, activeGoal);
    } catch (e) {
      yield GoalFailure(message: 'CANNOT LOAD GoalS', statusCode: 404);
    }
  }

  Stream<GoalState> _deleteGoal(DeleteGoal event) async* {
    final goals = (state as GoalSuccess).goals;
    final activeGoal = (state as GoalSuccess).activeGoal;
    yield GoalLoading();
    try {
      final goalId = event.goalId;
      await goalsRepository.deleteItem(goalId);
      goals.removeWhere((gl) => gl.id == goalId);
      yield GoalSuccess(goals, activeGoal);
    } catch (e) {
      yield GoalFailure(message: 'CANNOT LOAD GoalS', statusCode: 404);
    }
  }
}
