import 'package:flutter/material.dart';
import './Add_Meal.dart';
import '../bloc/Model/model.dart';

class EditMeal extends StatelessWidget {
  static const routeName = '/edit-meal';
  @override
  Widget build(BuildContext context) {
    final meal = ModalRoute.of(context).settings.arguments as MealItem;

    return Scaffold(
        appBar: AppBar(
          title: Text('Edit your meal'),
        ),
        body: AddMeal({
          'id': meal.id,
          'mealName': meal.mealName,
          'brandName': meal.brandName,
          'servingSize': meal.servingSize,
          'servingName': meal.servingName,
          'protein': meal.protein,
          'carbs': meal.carbs,
          'fats': meal.fats,
          'sugar': meal.sugar,
          'fiber': meal.fiber,
          'saturatedFat': meal.saturatedFat,
          'monosaturatedFat': meal.monosaturatedFat,
          'polyunsaturatedFat': meal.polyunsaturatedFat
        }));
  }
}
