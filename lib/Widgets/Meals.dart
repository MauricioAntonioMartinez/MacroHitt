import 'package:flutter/material.dart';
import '../Model/Meal.dart';
import 'MealItem.dart';

class MealWidget extends StatelessWidget {
  final Meal meal;
  MealWidget(this.meal);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: <Widget>[
      Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Theme.of(context).primaryColorLight),
          child:
              Text(meal.mealName, style: Theme.of(context).textTheme.subhead)),
      Column(
          children: <Widget>[...meal.mealsItems.map((i) => MealItemWidget(i))])
    ]));
  }
}
