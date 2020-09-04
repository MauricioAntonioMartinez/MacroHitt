import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../Model/model.dart';
import '../Repositories/recipie-item-repository.dart';
import '../Repositories/recipie-repository.dart';
import '../bloc.dart';

part 'recipie_event.dart';
part 'recipie_state.dart';

class RecipieBloc extends Bloc<RecipieEvent, RecipieState> {
  final MealBloc mealBloc;
  StreamSubscription mealTrackGroupSubscription;
  final RecipieRepository recipieRepository;
  final RecipieItemRepository recipieItemRepository;
  RecipieBloc(
      {this.mealBloc, this.recipieRepository, this.recipieItemRepository})
      : super(RecipieLoading()) {
    //final recipieId = (state as RecipieLoadSuccess).recipie;
    mealTrackGroupSubscription = mealBloc.listen((state) {
      if (state is MealLoadSuccess) {
        //  add(LoadRecipieMeals(recipieId.id));
      }
    });
  }

  @override
  Stream<RecipieState> mapEventToState(
    RecipieEvent event,
  ) async* {
    if (event is LoadRecipieMeals) {
      yield* _loadRecipie(event);
    } else if (event is AddEditMealRecipie) {
      yield* _addEditMeal(event);
    } else if (event is DeleteMealRecipie) {
      yield* _deleteMealRecipie(event);
    }
  }

  Stream<RecipieState> _saveRecipie() async* {
    final recipie = (state as RecipieLoadSuccess).recipie;
    try {
      final isNewRecipie = recipie.id == '';
      Recipie newRecipie;
      final recipieId = uuidd.v4();
      if (isNewRecipie)
        newRecipie = await recipieRepository.addItem(recipie, recipieId);
    } catch (e) {
      RecipieLoadFailure('CANNOT SAVE THE RECIPIE');
    }
  }

  Stream<RecipieState> _deleteMealRecipie(DeleteMealRecipie event) async* {
    final recipie = (state as RecipieLoadSuccess).recipie;
    yield RecipieLoading();
    try {
      final mealId = event.mealId;
      if (recipie.meals.length < 0 && recipie.id != "")
        RecipieLoadFailure(
            'The recipie cannot be empty please, delete via the trash icon.');
      else {
        if (recipie.id != '') await recipieItemRepository.deleteItem(mealId);
        recipie.recipieMeals.removeWhere((meal) => meal.id == mealId);
      }
      yield RecipieLoadSuccess(recipie);
    } catch (e) {
      RecipieLoadFailure('Couldn\'t delete the given meal.');
    }
  }

  Stream<RecipieState> _loadRecipie(LoadRecipieMeals event) async* {
    yield RecipieLoading();

    try {
      final userMeals = (mealBloc.state as MealLoadSuccess).myMeals;
      final recipie =
          await recipieRepository.findItem(event.recipieId, userMeals);
      print(recipie);
      yield RecipieLoadSuccess(recipie);
    } catch (e) {
      RecipieLoadFailure('Cannot load the recipie, please try later.');
      print(e);
    }
  }

  Stream<RecipieState> _addEditMeal(AddEditMealRecipie event) async* {
    final recipie = (state as RecipieLoadSuccess).recipie;
    yield RecipieLoading();
    try {
      final isNewRecipie = recipie.id == '';
      final newMeal = event.meal;
      final recipieIdMeal = uuidd.v4();
      final trackMealItem = RecipieItem(
          id: recipieIdMeal,
          mealId: newMeal.id,
          recipieId: recipie.id,
          qty: newMeal.servingSize);

      //Old Data
      final recipieMeals = recipie.meals;
      var oldCarbs = recipie.macrosConsumed.carbs;
      var oldFats = recipie.macrosConsumed.fats;
      var oldProtein = recipie.macrosConsumed.protein;

      //New Meal data
      // final newMeal = event.meal;
      final mealProtein = newMeal.protein;
      final mealCarbs = newMeal.carbs;
      final mealFats = newMeal.fats;

      // Meal Item
      MealItem mealFoundInRecipie;

      //Replacement
      final indexMeal = recipieMeals.indexWhere((m) => m.id == newMeal.id);
      if (indexMeal != -1) mealFoundInRecipie = recipieMeals[indexMeal];

      Macro newMacros;
      if (mealFoundInRecipie != null) {
        // JUST UPDATE
        final oldMealCarbs = mealFoundInRecipie.carbs;
        final oldMealFats = mealFoundInRecipie.fats;
        final oldMealProtein = mealFoundInRecipie.protein;
        newMacros = Macro(
            oldProtein - oldMealProtein + mealProtein,
            oldCarbs - oldMealCarbs + mealCarbs,
            oldFats - oldMealFats + mealFats);
        if (!isNewRecipie)
          await recipieItemRepository.updateItem(trackMealItem);
        final indexNewMeal =
            recipieMeals.indexWhere((meal) => meal.id == newMeal.id);
        recipieMeals[indexNewMeal] = newMeal;
      } else {
        if (!isNewRecipie) await recipieItemRepository.addItem(trackMealItem);
        recipieMeals.add(newMeal);
        newMacros = Macro(
            oldProtein + mealProtein, oldCarbs + mealCarbs, oldFats + mealFats);
      }
      if (!isNewRecipie) await recipieRepository.updateItem(recipie, newMacros);

      //  Yielding results
      final recipieFinal = Recipie(
          id: recipie.id,
          recipeMeal: recipie.recipeMeal,
          macrosConsumed: newMacros,
          meals: recipieMeals);
      yield RecipieLoadSuccess(recipieFinal);
    } catch (e) {
      print(e);
      TrackLoadedFailure('Cannot add or update the meal.');
    }
  }

  @override
  Future<void> close() {
    mealTrackGroupSubscription.cancel();
    return super.close();
  }
}
