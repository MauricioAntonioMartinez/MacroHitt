import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../Model/Meal.dart';

class MealItemWidget extends StatelessWidget {
  final MealItem mealItem;

  MealItemWidget(this.mealItem);

  @override
  Widget build(BuildContext context) {
    final Map<DismissDirection, double> dismissThresholds = {
      DismissDirection.vertical: 0.6
    };

    final macros = mealItem.protein.toString() +
        mealItem.carbs.toString() +
        mealItem.fats.toString();
    return Container(
      decoration: BoxDecoration(
          border: Border.symmetric(
              horizontal: BorderSide(color: Colors.white),
              vertical: BorderSide(color: Colors.grey, width: 0.1))),
      child: Dismissible(
        key: ValueKey('f'),
        // confirmDismiss: (direction) {
        //   print(direction);
        //   return;
        // },
        onDismissed: (d) {
          print(d);
        },
        dismissThresholds: dismissThresholds,
        background: Container(
          alignment: Alignment.centerLeft,
          color: Colors.green,
          child: IconButton(icon: Icon(Icons.check), onPressed: null),
        ),
        dragStartBehavior: DragStartBehavior.down,
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          color: Colors.red,
          child: IconButton(
              icon: Icon(Icons.delete), color: Colors.green, onPressed: null),
        ),
        child: ListTile(
          title: Text(
            mealItem.mealName,
            style: Theme.of(context).textTheme.subtitle,
          ),
          subtitle: Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('P:${mealItem.protein}g ',
                      style: TextStyle(
                          color: Colors.green, fontFamily: 'Questrial')),
                  Text('C:${mealItem.carbs}g ',
                      style: TextStyle(
                          color: Colors.blue, fontFamily: 'Questrial')),
                  Text('F:${mealItem.fats}g',
                      style:
                          TextStyle(color: Colors.red, fontFamily: 'Questrial'))
                ],
              ),
              Text('${mealItem.getCalories} Kcal')
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ),
    );
  }
}
