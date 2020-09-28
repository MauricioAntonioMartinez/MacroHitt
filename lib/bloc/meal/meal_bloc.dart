import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../Model/model.dart';
import '../Repositories/index.dart';

part 'meal_event.dart';
part 'meal_state.dart';

var uuid = Uuid();

class MealBloc extends Bloc<MealEvent, MealState> {
  final MealItemRepository mealItemRepository;
  MealBloc({this.mealItemRepository}) : super(MealLoading());

  @override
  Stream<MealState> mapEventToState(
    MealEvent event,
  ) async* {
    if (event is MealLoad) {
      yield* _mapMealTrackGroupLoadedToState();
    } else if (event is MealAdd) {
      yield* _addMeal(event);
    } else if (event is MealEdit) {
      yield* _editMeal(event);
    } else if (event is MealDelete) {
      yield* _deleteMeal(event);
    }
  }

  Stream<MealState> _deleteMeal(MealDelete event) async* {
    final meals = (state as MealLoadSuccess).myMeals;
    yield MealLoading();
    try {
      final mealId = event.id;
      await mealItemRepository.deleteItem(mealId);
      meals.removeWhere((meal) => meal.id == mealId);
      yield MealLoadSuccess(meals);
    } catch (e) {
      MealLoadFailure('CANNOT DELELETE');
    }
  }

  Stream<MealState> _mapMealTrackGroupLoadedToState() async* {
    yield MealLoading();
    try {
      final meals = await mealItemRepository.findItems();
      yield MealLoadSuccess(meals);
    } catch (_) {
      print(_);
      yield MealLoadFailure('CANNOT LOAD YOUR MEALS FAGGOT');
    }
  }

  Stream<MealState> _addMeal(MealAdd event) async* {
    final oldMeals = (state as MealLoadSuccess).myMeals;
    yield MealLoading();
    try {
      final meal = await mealItemRepository.addItem(event.mealItem);
      meal.setOrigin = MealOrigin.Search;
      oldMeals.add(meal);
      yield MealLoadSuccess(oldMeals);
    } catch (_) {
      print(_);
      MealLoadFailure('SOMETHING WENT WRONG');
    }
  }

  Stream<MealState> _editMeal(MealEdit event) async* {
    final prevMeals = (state as MealLoadSuccess).myMeals;
    yield MealLoading();
    try {
      final updatedMeal = event.mealItem;
      await mealItemRepository.updateItem(updatedMeal);
      final indexUpdatedMeal =
          prevMeals.indexWhere((m) => m.id == updatedMeal.id);
      prevMeals[indexUpdatedMeal] = updatedMeal;

      yield MealLoadSuccess(prevMeals);
    } catch (e) {
      MealLoadFailure('CANNOT UPDATE MEAL');
    }
  }
}
