import 'dart:async';

import 'package:HIIT/data/meals_db.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/day_track.dart';
import '../Model/model.dart';

part 'meal_event.dart';
part 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  MealBloc() : super(MealLoading());

  @override
  Stream<MealState> mapEventToState(
    MealEvent event,
  ) async* {
    if (event is MealLoad) {
      yield* _mapMealTrackGroupLoadedToState();
    } else if (event is MealAdd) {
      yield* _addMeal(event);
    }
  }

  Stream<MealState> _mapMealTrackGroupLoadedToState() async* {
    try {
      // fetching from a database
      final meals = myMeals;

      yield MealLoadSuccess(meals);
    } catch (_) {
      yield MealLoadFailure('CANNOT LOAD YOUR MEALS');
    }
  }

  Stream<MealState> _addMeal(MealAdd event) async* {
    try {
      final currentMeals = (state as MealLoadSuccess).myMeals;
      print(event.mealItem);
      currentMeals.add(event.mealItem);
      yield MealLoadSuccess(currentMeals);
    } catch (_) {}
  }
}
