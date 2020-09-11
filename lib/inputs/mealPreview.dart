import 'package:flutter/material.dart';

import '../bloc/Model/model.dart';

List<Map<String, dynamic>> mealPreviewDetails(
        MealItem meal, BuildContext context) =>
    [
      {
        "label": "Calories",
        "value": meal.getCalories,
        "color": Theme.of(context).primaryColorDark
      },
      {
        "label": "Total Fats",
        "value": meal.getFats,
        "color": Theme.of(context).errorColor,
        "details": [
          {
            "Saturated Fat":
                meal.saturatedFat == null ? 0.0 : meal.saturatedFat,
          },
          {
            "Monosaturated Fat":
                meal.monosaturatedFat == null ? 0.0 : meal.monosaturatedFat,
          },
          {
            "Polyunsaturated Fat":
                meal.polyunsaturatedFat == null ? 0.0 : meal.polyunsaturatedFat
          },
        ],
      },
      {
        "label": "TotalCarbs",
        "value": meal.getCarbs,
        "color": Colors.blue,
        "details": [
          {
            "Sugar": meal.sugar == null ? 0.0 : meal.sugar,
          },
          {
            "Fiber": meal.fiber == null ? 0.0 : meal.fiber,
          },
        ],
      },
      {"label": "Protein", "value": meal.getProtein, 'color': Colors.green},
      {"label": "Sodium", "value": 0},
    ];
