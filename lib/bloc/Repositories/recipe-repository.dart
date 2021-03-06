import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../db/db.dart';
import '../Model/Recipe.dart';
import '../Model/model.dart';

class RecipeRepository {
  Future<Recipe> addItem(Recipe recipe) async {
    final database = await db();
    await database.insert(
      'recipe',
      {
        'id': recipe.id,
        'recipeName': recipe.recipeMeal,
        'protein': recipe.getProtein,
        'carbs': recipe.getCarbs,
        'fats': recipe.getFats,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return Recipe(id: recipe.id, recipeMeal: recipe.recipeMeal, meals: []);
  }

  Future<void> changeRecipeName(String newName,String recipeId) async { 
    final database = await db();
     await database.update(
        'recipe',
        {
          'recipeName': newName
        },
        where: 'id=?',
        whereArgs: [recipeId]);
  }

  Future<void> deleteItem(String recipeId) async {
    final database = await db();
    await database
        .delete('recipe_meal', where: 'recipe_id=?', whereArgs: [recipeId]);
    await database.delete('recipe', where: 'id=?', whereArgs: [recipeId]);
  }

  Future<Recipe> updateItem(Recipe recipe, [Macro macro]) async {
    final database = await db();
    await database.update(
        'recipe',
        {
          'protein': macro.protein,
          'fats': macro.fats,
          'carbs': macro.carbs,
          'recipeName': recipe.recipeMeal
        },
        where: 'id=?',
        whereArgs: [recipe.id]);
    return recipe;
  }

  Future<List<MealItem>> findItems() async {
    final database = await db();
    final recipes = await database.query('recipe');

    return recipes.map((r) {
      return MealItem(
          servingName: 'serving',
          brandName: "",
          carbs: r['carbs'],
          fats: r['fats'],
          protein: r['protein'],
          origin: MealOrigin.Recipe,
          mealName: r['recipeName'],
          id: r['id'],
          servingSize: 1);
    }).toList();
  }

  Future<void> updateMacrosRecipe(MealItem prevMeal, [MealItem newMeal]) async {
    final database = await db();
    final delete = newMeal == null;

    final recipes = await database.rawQuery('''
      SELECT protein,carbs,fats,R.id as recipeId,qty FROM recipe R INNER JOIN recipe_meal M ON R.id = M.recipe_id WHERE
        M.meal_id = ?; 
    ''', [prevMeal.id]);

    if (delete)
      await database.delete(
        'recipe_meal',
        where: 'meal_id=? ',
        whereArgs: [prevMeal.id],
      );

    for (final recipe in recipes) {
      final qty = recipe['qty'];
      await database.update(
          'recipe',
          {
            "protein": recipe['protein'] -
                prevMeal.protein * qty +
                (newMeal == null ? 0.0 : newMeal.protein) * qty,
            "carbs": recipe['carbs'] -
                prevMeal.carbs * qty +
                (newMeal == null ? 0.0 : newMeal.carbs) * qty,
            "fats": recipe['fats'] -
                prevMeal.fats * qty +
                (newMeal == null ? 0.0 : newMeal.fats) * qty,
          },
          where: 'id=?',
          whereArgs: [recipe['recipeId']]);
    }
  }

  Future<Recipe> findItem(String recipeId, [List<MealItem> userMeals]) async {
    if (recipeId == null) {
      return Recipe(id: '', recipeMeal: '', meals: []);
    }

    final database = await db();
    final recipe =
        await database.query('recipe', where: "id=?", whereArgs: [recipeId]);

    if (recipe.length < 1) return Recipe(id: '', recipeMeal: '', meals: []);

    final List<Map<String, dynamic>> mealsRecipe = await database
        .query('recipe_meal', where: "recipe_id=?", whereArgs: [recipeId]);
    final List<RecipeItem> recipeMeals = [];
    mealsRecipe.forEach((meal) {
      recipeMeals.add(RecipeItem(
          id: meal['id'],
          mealId: meal['meal_id'],
          qty: meal['qty'],
          recipeId: meal['recipe_id']));
    });
    final recipeName = recipe[0]['recipeName'];

    final meals = Recipe.recipeMealsToItemMeals(userMeals, recipeMeals);
    return Recipe(id: recipeId, recipeMeal: recipeName, meals: meals);
  }
}
