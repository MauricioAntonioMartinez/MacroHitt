import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../Model/model.dart';
import '../Repositories/recipe-item-repository.dart';
import '../Repositories/recipe-repository.dart';
import '../bloc.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final MealBloc mealBloc;
  StreamSubscription mealTrackGroupSubscription;
  final RecipeRepository recipeRepository;
  final RecipeItemRepository recipeItemRepository;
  RecipeBloc({this.mealBloc, this.recipeRepository, this.recipeItemRepository})
      : super(RecipeLoading()) {
    var recipeId;
    if (state is RecipeLoadSuccess) {
      recipeId = (state as RecipeLoadSuccess).recipe.id;
    }
    mealTrackGroupSubscription = mealBloc.listen((state) {
      if (state is MealLoadSuccess && recipeId != null) {
        add(LoadRecipeMeals(recipeId));
      } else {
        add(LoadRecipes());
      }
    });
  }

  @override
  Stream<RecipeState> mapEventToState(
    RecipeEvent event,
  ) async* {
    if (event is LoadRecipes) {
      yield* _loadRecipes();
    } else if (event is LoadRecipeMeals) {
      yield* _loadRecipe(event);
    } else if (event is AddEditMealRecipe) {
      yield* _addEditMeal(event);
    } else if (event is DeleteMealRecipe) {
      yield* _deleteMealRecipe(event);
    } else if (event is SaveRecipe) {
      yield* _saveRecipe(event);
    } else if (event is DeleteRecipe) {
      yield* _deleteRecipe();
    } else if (event is UpdateRecipeName) {
      yield* _updateRecipeName(event);
    }
  }

  Stream<RecipeState> _loadRecipes() async* {
    yield RecipeLoading();
    try {
      final recipes = await recipeRepository.findItems();
      yield Recipes(recipes);
    } catch (e) {
      yield RecipeLoadFailure('Cannot load your recipes');
    }
  }

  Stream<RecipeState> _updateRecipeName(UpdateRecipeName event) async* {
      final recipe =  (state as RecipeLoadSuccess).recipe;
      yield RecipeLoading();
    try {
      final newName  = event.recipeName;
      recipe.recipeMeal=newName;
      
      await recipeRepository.changeRecipeName(newName, recipe.id);
      yield RecipeLoadSuccess(recipe);
    }catch(e) { 
      yield RecipeLoadFailure('Cannto update the recipe meal');
    }
  }

  Stream<RecipeState> _deleteRecipe() async* {
    yield RecipeLoading();
    final recipe = (state as RecipeLoadSuccess).recipe;
    try {
      await recipeRepository.deleteItem(recipe.id);

      yield RecipeDeleteSuccess();
      yield RecipeLoadSuccess(Recipe(id: '', meals: [], recipeMeal: ''));
    } catch (e) {
      yield RecipeLoadFailure('Cannot save the recipe');
    }
  }

  Stream<RecipeState> _saveRecipe(SaveRecipe event) async* {
    final recipe = (state as RecipeLoadSuccess).recipe;
    try {
      if (recipe.meals.length < 1) {
        yield RecipeLoadFailure('No meals added.');
      } else {
        final recipeName = event.recipeName;
        recipe.setRecipeMeal = recipeName;
        final recipeId = uuidd.v4();
        recipe.setId = recipeId;
        await recipeRepository.addItem(recipe);
        for (final meal in recipe.meals) {
          await recipeItemRepository.addItem(RecipeItem(
              id: uuidd.v4(),
              mealId: meal.id,
              qty: meal.servingSize,
              recipeId: recipeId));
        }
        yield RecipeSavedSuccess();
      }

      yield RecipeLoadSuccess(recipe);
    } catch (e) {
      RecipeLoadFailure('CANNOT SAVE THE Recipe');
    }
  }

  Stream<RecipeState> _deleteMealRecipe(DeleteMealRecipe event) async* {
    final recipe = (state as RecipeLoadSuccess).recipe;
    yield RecipeLoading();
    try {
      final mealId = event.mealId;
      final oldProtein = recipe.getProtein;
      final oldCarbs = recipe.getCarbs;
      final oldFats = recipe.getFats;
      final newMeals = recipe.meals;
      final removeItemIndex =
          recipe.meals.indexWhere((meal) => meal.id == mealId);
      final mealProtein = recipe.meals[removeItemIndex].protein;
      final mealCarbs = recipe.meals[removeItemIndex].carbs;
      final mealFats = recipe.meals[removeItemIndex].fats;
      final newMacros = Macro(
          oldProtein - mealProtein, oldCarbs - mealCarbs, oldFats - mealFats);
      if (recipe.id != '') {
        await recipeItemRepository.deleteItem(mealId, recipe.id);
        await recipeRepository.updateItem(recipe, newMacros);
      }
      newMeals.removeAt(removeItemIndex);
      final newRecipe =
          Recipe(id: recipe.id, meals: newMeals, recipeMeal: recipe.recipeMeal);

      yield RecipeLoadSuccess(newRecipe);
    } catch (e) {
      RecipeLoadFailure('Couldn\'t delete the given meal.');
    }
  }

  Stream<RecipeState> _loadRecipe(LoadRecipeMeals event) async* {
    yield RecipeLoading();

    try {
      final userMeals = (mealBloc.state as MealLoadSuccess).myMeals;
      final recipe = await recipeRepository.findItem(event.recipeId, userMeals);
      print(recipe);
      yield RecipeLoadSuccess(recipe);
    } catch (e) {
      RecipeLoadFailure('Cannot load the recipe, please try later.');
      print(e);
    }
  }

  Stream<RecipeState> _addEditMeal(AddEditMealRecipe event) async* {
    final recipe = (state as RecipeLoadSuccess).recipe;
    yield RecipeLoading();
    try {
      final isNewRecipe = recipe.id == '';
      final newMeal = event.meal;
      newMeal.setOrigin = MealOrigin.Recipe;
      final recipeIdMeal = uuidd.v4();
      final trackMealItem = RecipeItem(
          id: recipeIdMeal,
          mealId: newMeal.id,
          recipeId: recipe.id,
          qty: newMeal.servingSize);

      //Old Data
      final recipeMeals = recipe.meals;
      var oldCarbs = recipe.getCarbs;
      var oldFats = recipe.getFats;
      var oldProtein = recipe.getProtein;

      //New Meal data
      // final newMeal = event.meal;
      final mealProtein = newMeal.protein;
      final mealCarbs = newMeal.carbs;
      final mealFats = newMeal.fats;

      // Meal Item
      MealItem mealFoundInRecipe;

      //Replacement
      final indexMeal = recipeMeals.indexWhere((m) => m.id == newMeal.id);
      if (indexMeal != -1) mealFoundInRecipe = recipeMeals[indexMeal];

      Macro newMacros;
      if (mealFoundInRecipe != null) {
        // JUST UPDATE
        final oldMealCarbs = mealFoundInRecipe.carbs;
        final oldMealFats = mealFoundInRecipe.fats;
        final oldMealProtein = mealFoundInRecipe.protein;
        newMacros = Macro(
            oldProtein - oldMealProtein + mealProtein,
            oldCarbs - oldMealCarbs + mealCarbs,
            oldFats - oldMealFats + mealFats);
        if (!isNewRecipe) await recipeItemRepository.updateItem(trackMealItem);
        final indexNewMeal =
            recipeMeals.indexWhere((meal) => meal.id == newMeal.id);
        recipeMeals[indexNewMeal] = newMeal;
      } else {
        if (!isNewRecipe) await recipeItemRepository.addItem(trackMealItem);
        recipeMeals.add(newMeal);
        newMacros = Macro(
            oldProtein + mealProtein, oldCarbs + mealCarbs, oldFats + mealFats);
      }
      if (!isNewRecipe) await recipeRepository.updateItem(recipe, newMacros);

      //  Yielding results
      final recipeFinal = Recipe(
          id: recipe.id, recipeMeal: recipe.recipeMeal, meals: recipeMeals);
      yield RecipeLoadSuccess(recipeFinal);
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
