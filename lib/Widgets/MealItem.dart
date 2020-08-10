import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../bloc/Model/model.dart';

class MealItemWidget extends StatelessWidget {
  final MealItem mealItem;

  MealItemWidget(this.mealItem);

  @override
  Widget build(BuildContext context) {
    final Map<DismissDirection, double> dismissThresholds = {
      DismissDirection.vertical: 0.6
    };

    return Container(
      decoration: BoxDecoration(
          border: Border.symmetric(
              horizontal: BorderSide(color: Colors.white),
              vertical: BorderSide(color: Colors.grey, width: 0.1))),
      child: Dismissible(
        key: ValueKey('f'),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Do you really want to remove this meal?',
                        style: Theme.of(context).textTheme.subtitle),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                      FlatButton(
                        child: Text('No', style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      )
                    ],
                  ));
        },
        onDismissed: (d) {
          print(d);
        },
        dismissThresholds: dismissThresholds,
        background: Container(
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
                  Text('P:${mealItem.protein.toStringAsFixed(1)}g ',
                      style: TextStyle(
                          color: Colors.green, fontFamily: 'Questrial')),
                  Text('C:${mealItem.carbs.toStringAsFixed(1)}g ',
                      style: TextStyle(
                          color: Colors.blue, fontFamily: 'Questrial')),
                  Text('F:${mealItem.fats.toStringAsFixed(1)}g',
                      style:
                          TextStyle(color: Colors.red, fontFamily: 'Questrial'))
                ],
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('${mealItem.servingSize} ${mealItem.servingName}'),
              Text(
                '${mealItem.getCalories.toStringAsFixed(1)} Kcal',
                style: TextStyle(color: Colors.black45),
              )
            ],
          ),
        ),
      ),
    );
  }
}
