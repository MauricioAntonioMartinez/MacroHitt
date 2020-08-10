import 'package:flutter/material.dart';
import '../bloc/Model/model.dart';
import 'MealItem.dart';

class MealWidget extends StatelessWidget {
  final List<MealItem> mealGrup;
  final String mealName;
  MealWidget(this.mealGrup, this.mealName);

  @override
  Widget build(BuildContext context) {
    final totalCals = mealGrup.fold(0, (acc, meal) => acc + meal.getCalories);
    return Card(
        child: Column(children: <Widget>[
      Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Theme.of(context).primaryColorLight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(mealName, style: Theme.of(context).textTheme.subhead),
              Text('${totalCals} Kcal',
                  style: Theme.of(context).textTheme.subhead),
            ],
          )),
      Column(children: <Widget>[...mealGrup.map((i) => MealItemWidget(i))])
    ]));
  }
}
