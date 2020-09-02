import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../Repositories/recipie-item-repository.dart';
import '../Repositories/recipie-repository.dart';
import '../bloc.dart';
import '../Model/model.dart';
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
    final recipieId = (state as RecipieLoadSuccess).recipie;
    mealTrackGroupSubscription = mealBloc.listen((state) {
      if (state is MealLoadSuccess) {
        add(LoadRecipieMeals(recipieId.id));
      }
    });
  }

  @override
  Stream<RecipieState> mapEventToState(
    RecipieEvent event,
  ) async* {
    if (event is LoadRecipieMeals) {
      yield* _loadRecipie(event);
    } else if (event is AddMeal) {
      yield* _addEditMeal(event);
    } else if (event is DeleteMeal) {
      yield* _deleteMeal(event);
    }
  }

  Stream<RecipieState> _deleteMeal(DeleteMeal event) async* {
    final recipie = (state as RecipieLoadSuccess).recipie;
    yield RecipieLoading();
    try {
      final mealId = event.mealId;
      if (recipie.meals.length < 0)
        RecipieLoadFailure('CANNOT DELETE THE LAST MEAL ITEM');
      else {
        await recipieItemRepository.deleteItem(mealId);
        recipie.recipieMeals.removeWhere((meal) => meal.id == mealId);
      }
      yield RecipieLoadSuccess(recipie);
    } catch (e) {
      RecipieLoadFailure('CANNOT DELELETE');
    }
  }

  Stream<RecipieState> _loadRecipie(LoadRecipieMeals event) async* {
    yield RecipieLoading();
    if (mealBloc.state is RecipieLoadSuccess) {
      try {
        final userMeals = (mealBloc.state as MealLoadSuccess).myMeals;
        final recipie =
            await recipieRepository.findItem(event.recipieId, userMeals);
        yield RecipieLoadSuccess(recipie);
      } catch (e) {
        print(e);
      }
    }
  }

  Stream<RecipieState> _addEditMeal(AddMeal event) async* {
    final recipie = (state as RecipieLoadSuccess).recipie;
    yield RecipieLoading();
    try {
      final newMeal = event.meal;
      final isNewRecipie = recipie.id == '';
      Recipie newRecipie;
      final recipieId = uuidd.v4();
      if (isNewRecipie)
        newRecipie = await recipieRepository.addItem(recipie, recipieId);
      else
        newRecipie = recipie;
      final recipieIdMeal = uuidd.v4();

      final trackMealItem = RecipieItem(
          id: recipieIdMeal,
          mealId: newMeal.id,
          recipieId: newRecipie.id,
          qty: newMeal.servingSize);

      //Old Data
      final recipieMeals = newRecipie.meals;
      var oldCarbs = newRecipie.macrosConsumed.carbs;
      var oldFats = newRecipie.macrosConsumed.fats;
      var oldProtein = newRecipie.macrosConsumed.protein;

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
        await recipieItemRepository.updateItem(trackMealItem);
        final indexNewMeal =
            recipieMeals.indexWhere((meal) => meal.id == newMeal.id);
        recipieMeals[indexNewMeal] = newMeal;
      } else {
        await recipieItemRepository.addItem(trackMealItem);
        newMacros = Macro(
            oldProtein + mealProtein, oldCarbs + mealCarbs, oldFats + mealFats);
      }
      await recipieRepository.updateItem(newRecipie, newMacros);

      //  Yielding results
      final recipieFinal = Recipie(
          id: newRecipie.id,
          recipeMeal: newRecipie.recipeMeal,
          macrosConsumed: newMacros,
          meals: recipieMeals);
      yield RecipieLoadSuccess(recipieFinal);
    } catch (e) {
      print(e);
      TrackLoadedFailure('WENT GRONG');
    }
  }

  @override
  Future<void> close() {
    mealTrackGroupSubscription.cancel();
    return super.close();
  }
}
