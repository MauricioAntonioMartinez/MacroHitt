import 'package:flutter/cupertino.dart';

import './model.dart';

enum MealOrigin { Track, Recipe, Search }

class MealItem extends Macro {
  String id;
  final String mealName;
  final String servingName;
  final String brandName;
  double servingSize;
  double protein;
  double carbs;
  double fats;
  final double fiber;
  final double sugar;
  final double monosaturatedFat;
  final double polyunsaturatedFat;
  final double saturatedFat;
  MealOrigin origin;

  MealItem(
      {this.id,
      @required this.mealName,
      @required this.protein,
      @required this.carbs,
      @required this.fats,
      this.brandName = "",
      @required this.servingName,
      @required this.servingSize,
      @required this.origin,
      this.fiber = 0,
      this.sugar = 0,
      this.polyunsaturatedFat = 0,
      this.saturatedFat = 0,
      this.monosaturatedFat = 0})
      : super(protein, carbs, fats);

  MealItem updateServingSize(double newQty) {
    final oldServingSize = this.servingSize;
    this.servingSize = newQty;
    this.carbs = (this.carbs / oldServingSize) * newQty;
    this.protein = (this.protein / oldServingSize) * newQty;
    this.fats = (this.fats / oldServingSize) * newQty;
    return this;
  }

  set setOrigin(MealOrigin origin) {
    this.origin = origin;
  }

  Map<String, dynamic> toMap() {
    return {
      'mealName': mealName,
      'brandName': brandName,
      'servingName': servingName,
      'servingSize': servingSize,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'sugar': sugar,
      'fiber': fiber,
      'monosaturatedFat': monosaturatedFat,
      'polyunsaturatedFat': polyunsaturatedFat,
      'saturatedFat': saturatedFat
    };
  }

  void setId(String id) {
    this.id = id;
  }
}
