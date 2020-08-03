import 'package:flutter/material.dart';
import '../Model/Meal.dart';
import '../Widgets/Meals.dart';
import '../Widgets/Controls/Macros.dart';

class Tracking extends StatefulWidget {
  @override
  _Tracking createState() => _Tracking();
}

class _Tracking extends State<Tracking> {
  final MacroDay mealday =
      MacroDay(date: DateTime.now(), goals: Macro(20, 50, 100), meals: [
    Meal('Breakfast', [
      MealItem(mealName: 'Ensalada', carbs: 23, fats: 20, protein: 23),
      MealItem(mealName: 'Ensalada', carbs: 23, fats: 20, protein: 23),
      MealItem(mealName: 'Ensalada', carbs: 23, fats: 20, protein: 23)
    ]),
    Meal('Lunch', [
      MealItem(mealName: 'Ensalada', carbs: 23, fats: 20, protein: 23),
      MealItem(mealName: 'Ensalada', carbs: 23, fats: 20, protein: 23),
      MealItem(mealName: 'Ensalada', carbs: 23, fats: 20, protein: 23)
    ]),
    Meal('Dinner', [
      MealItem(mealName: 'Ensalada', carbs: 23, fats: 20, protein: 23),
      MealItem(mealName: 'Ensalada', carbs: 23, fats: 20, protein: 23),
      MealItem(mealName: 'Ensalada', carbs: 23, fats: 20, protein: 23)
    ])
  ]);

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Macros(),
          Expanded(
              child: ListView(
            children: <Widget>[
              ...mealday.meals.map((meal) => MealWidget(meal))
            ],
          )),
        ],
      ),
    );
  }
}
