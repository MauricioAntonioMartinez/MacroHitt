import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../db/db.dart';
import '../Model/model.dart';

part 'meal_event.dart';
part 'meal_state.dart';

var uuid = Uuid();

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
      final database = await db();
      await database.delete(
        'mealitem',
        where: "id = ?",
        whereArgs: [mealId],
      );
      meals.removeWhere((meal) => meal.id == mealId);
      yield MealLoadSuccess(meals);
    } catch (e) {
      MealLoadFailure('CANNOT DELELETE');
    }
  }

  Stream<MealState> _mapMealTrackGroupLoadedToState() async* {
    yield MealLoading();
    try {
      final database = await db();
      final List<Map<String, dynamic>> fetchMeals =
          await database.query('mealitem');
      List<MealItem> mealsFetched = [];
      fetchMeals.forEach((i) {
        mealsFetched.add(MealItem(
            id: i['id'],
            brandName: i['brandName'],
            mealName: i['mealName'],
            servingName: i['servingName'],
            servingSize: i['servingSize'],
            carbs: i['carbs'],
            fats: i['fats'],
            protein: i['protein'],
            monosaturatedFat: i['monosaturatedFat'],
            polyunsaturatedFat: i['polyunsaturatedFat'],
            saturatedFat: i['saturatedFat'],
            sugar: i['sugar'],
            fiber: i['fiber']));
      });
      yield MealLoadSuccess(mealsFetched);
    } catch (_) {
      print(_);
      yield MealLoadFailure('CANNOT LOAD YOUR MEALS');
    }
  }

  Stream<MealState> _addMeal(MealAdd event) async* {
    final oldMeals = (state as MealLoadSuccess).myMeals;
    yield MealLoading();
    try {
      final id = uuid.v4();
      final newMeal = event.mealItem;
      newMeal.setId(id);
      final database = await db();
      await database.insert(
        'mealitem',
        {'id': id, ...newMeal.toMap()},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      oldMeals.add(event.mealItem);
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
      print(updatedMeal);
      final database = await db();
      await database.update('mealitem', updatedMeal.toMap(),
          where: 'id=?', whereArgs: [updatedMeal.id]);

      final indexUpdatedMeal =
          prevMeals.indexWhere((m) => m.id == updatedMeal.id);
      prevMeals[indexUpdatedMeal] = updatedMeal;

      yield MealLoadSuccess(prevMeals);
    } catch (e) {
      MealLoadFailure('CANNOT UPDATE MEAL');
    }
  }
}
