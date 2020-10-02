import 'dart:async';

import 'package:HIIT/bloc/Repositories/recipe-repository.dart';
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
  final TrackRepository trackRepository;
  final RecipeRepository recipeRepository;
  MealBloc(
      {@required this.mealItemRepository,
      @required this.trackRepository,
      @required this.recipeRepository})
      : super(MealLoading());

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
    // TODO: SOMETHING IS WRONG HERE
    try {
      final mealId = event.id;
      final prevMealIndex = meals.indexWhere((meal) => meal.id == mealId);
      await mealItemRepository.deleteItem(mealId);
      await recipeRepository.updateMacrosRecipe(meals[prevMealIndex]);
      await trackRepository.updateMacrosTracks(meals[prevMealIndex]);
      meals.removeAt(prevMealIndex);
      yield MealLoadSuccess(meals);
    } catch (e) {
      print(e);
      MealLoadFailure('CANNOT DELETE');
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

      final prevMeal = prevMeals[indexUpdatedMeal];

      await recipeRepository.updateMacrosRecipe(prevMeal, updatedMeal);
      await trackRepository.updateMacrosTracks(prevMeal, updatedMeal);

      prevMeals[indexUpdatedMeal] = updatedMeal;

      yield MealLoadSuccess(prevMeals);
    } catch (e) {
      MealLoadFailure('CANNOT UPDATE MEAL');
    }
  }
}
