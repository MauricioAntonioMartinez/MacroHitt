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
    final recipieId = (state as RecipieLoadSuccess).recipieId;
    mealTrackGroupSubscription = mealBloc.listen((state) {
      if (state is MealLoadSuccess) {
        add(LoadRecipieMeals(recipieId));
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
      yield* _addMeal(event);
    } else if (event is UpdateMeal) {
      yield* _editMeal(event);
    } else if (event is DeleteMeal) {
      yield* _deleteMeal(event);
    }
  }

  Stream<RecipieState> _deleteMeal(DeleteMeal event) async* {
    final recipie = (state as RecipieLoadSuccess);
    yield RecipieLoading();
    try {
      final mealId = event.mealId;
      await recipieItemRepository.deleteItem(mealId);
      recipie.recipieMeals.removeWhere((meal) => meal.id == mealId);
      yield RecipieLoadSuccess(recipie.recipieMeals, recipie.recipieId);
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
        // Recipie.recipieMealsToItemMeals(userMeals, recipie.meals);
        //TODO: CONVERT RECPIEMELAS INTO ITEMMELAS
        yield RecipieLoadSuccess(recipie.meals, event.recipieId);
      } catch (e) {
        print(e);
      }
    }
  }

  Stream<RecipieState> _addMeal(AddMeal event) async* {
    final oldMeals = (state as RecipieLoadSuccess).recipieMeals;
    yield RecipieLoading();
    try {
      //final meal = await mealItemRepository.addItem(event.meal);
      //oldMeals.add(meal);
      // yield RecipieLoadSuccess(oldMeals);
    } catch (_) {
      print(_);
      RecipieLoadFailure('SOMETHING WENT WRONG');
    }
  }

  Stream<RecipieState> _editMeal(UpdateMeal event) async* {
    final prevMeals = (state as RecipieLoadSuccess).recipieMeals;
    yield RecipieLoading();
    try {
      final updatedMeal = event.meal;
      // await mealItemRepository.updateItem(updatedMeal);
      final indexUpdatedMeal =
          prevMeals.indexWhere((m) => m.id == updatedMeal.id);
      prevMeals[indexUpdatedMeal] = updatedMeal;

      //  yield RecipieLoadSuccess(prevMeals);
    } catch (e) {
      RecipieLoadFailure('CANNOT UPDATE MEAL');
    }
  }
}
