import 'package:flutter/material.dart';

import '../../bloc/Model/model.dart';
import 'MealItem.dart';

class MealGroup extends StatelessWidget {
  final List<MealItem> mealGrup;
  final MealGroupName groupName;
  MealGroup(this.mealGrup, [this.groupName]);

  @override
  Widget build(BuildContext context) {
    String grpName;
    if (groupName == MealGroupName.BreakFast) {
      grpName = 'BreakFast';
    } else if (groupName == MealGroupName.Dinner) {
      grpName = 'Dinner';
    } else if (groupName == MealGroupName.Lunch) {
      grpName = 'Lunch';
    } else if (groupName == MealGroupName.Snack) {
      grpName = 'Snack';
    }
    final totalCals = mealGrup.fold(0, (acc, meal) => acc + meal.getCalories);
    return Card(
        child: Column(children: <Widget>[
      if (grpName != null)
        Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration:
                BoxDecoration(color: Theme.of(context).primaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(grpName, style: Theme.of(context).textTheme.subtitle1),
                Text('${totalCals.toStringAsFixed(1)} Kcal',
                    style: Theme.of(context).textTheme.subtitle1),
              ],
            )),
      Column(
          children: mealGrup
              .map((i) => MealItemWidget(i, true, i.origin, groupName))
              .toList())
    ]));
  }
}
