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
    var recipieId;

    // if (state is RecipieLoadSuccess){

    // }

    mealTrackGroupSubscription = mealBloc.listen((state) {
      if (state is MealLoadSuccess) {
        if (recipieId !=
            null) // if we are in edit and want to update the meals if the user changed
          add(LoadRecipieMeals(''));
        else
          add(LoadRecipies()); //Load all the recipies, for search tracking
      }
    });
  }

  @override
  Stream<RecipieState> mapEventToState(
    RecipieEvent event,
  ) async* {
    if (event is LoadRecipies) {
      yield* _loadRecipies();
    } else if (event is LoadRecipieMeals) {
      yield* _loadRecipie(event);
    } else if (event is AddEditMealRecipie) {
      yield* _addEditMeal(event);
    } else if (event is DeleteMealRecipie) {
      yield* _deleteMealRecipie(event);
    } else if (event is SaveRecipie) {
      yield* _saveRecipie(event);
    } else if (event is DeleteRecipie) {
      yield* _deleteRecipie();
    } else if (event is UpdateRecipieName) {
      yield* _updateRecipieName(event);
    }
  }

  Stream<RecipieState> _loadRecipies() async* {
    try {
      final recipies = await recipieRepository.findItems();
      yield Recipies(recipies);
    } catch (e) {
      yield RecipieLoadFailure('Cannot load your recipies');
    }
  }

  Stream<RecipieState> _updateRecipieName(UpdateRecipieName event) async* {
    //TODO: implement updating the name in edit mode in runtime
  }

  Stream<RecipieState> _deleteRecipie() async* {
    yield RecipieLoading();
    final recipie = (state as RecipieLoadSuccess).recipie;
    try {
      await recipieRepository.deleteItem(recipie.id);

      yield RecipieDeleteSuccess();
      yield RecipieLoadSuccess(Recipie(
          id: '', macrosConsumed: Macro(0, 0, 0), meals: [], recipeMeal: ''));
    } catch (e) {
      yield RecipieLoadFailure('Cannot save the recipie');
    }
  }

  Stream<RecipieState> _saveRecipie(SaveRecipie event) async* {
    final recipie = (state as RecipieLoadSuccess).recipie;
    try {
      if (recipie.meals.length < 1) {
        yield RecipieLoadFailure('No meals added.');
      } else {
        final recipieName = event.recipieName;
        recipie.setRecipieMeal = recipieName;
        final recipieId = uuidd.v4();
        recipie.setId = recipieId;
        await recipieRepository.addItem(recipie);
        for (final meal in recipie.meals) {
          await recipieItemRepository.addItem(RecipieItem(
              id: uuidd.v4(),
              mealId: meal.id,
              qty: meal.servingSize,
              recipieId: recipieId));
        }
        yield RecipieSavedSuccess();
      }

      yield RecipieLoadSuccess(recipie);
    } catch (e) {
      RecipieLoadFailure('CANNOT SAVE THE RECIPIE');
    }
  }

  Stream<RecipieState> _deleteMealRecipie(DeleteMealRecipie event) async* {
    final recipie = (state as RecipieLoadSuccess).recipie;
    yield RecipieLoading();
    try {
      final mealId = event.mealId;
      final oldProtein = recipie.macrosConsumed.protein;
      final oldCarbs = recipie.macrosConsumed.carbs;
      final oldFats = recipie.macrosConsumed.fats;
      final newMeals = recipie.meals;
      if (recipie.meals.length == 1 && recipie.id != "") {
        RecipieLoadFailure(
            'The recipie cannot be empty please, delete via the trash icon.');
        yield RecipieLoadSuccess(recipie);
      } else {
        final removeItemIndex =
            recipie.meals.indexWhere((meal) => meal.id == mealId);
        final mealProtein = recipie.meals[removeItemIndex].protein;
        final mealCarbs = recipie.meals[removeItemIndex].carbs;
        final mealFats = recipie.meals[removeItemIndex].fats;
        final newMacros = Macro(
            oldProtein - mealProtein, oldCarbs - mealCarbs, oldFats - mealFats);
        if (recipie.id != '') {
          await recipieItemRepository.deleteItem(mealId, recipie.id);
          await recipieRepository.updateItem(recipie, newMacros);
        }
        newMeals.removeAt(removeItemIndex);
        final newRecipie = Recipie(
            id: recipie.id,
            macrosConsumed: newMacros,
            meals: newMeals,
            recipeMeal: recipie.recipeMeal);

        yield RecipieLoadSuccess(newRecipie);
      }
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
      newMeal.setOrigin = MealOrigin.Recipie;
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
