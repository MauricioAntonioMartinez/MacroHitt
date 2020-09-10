import 'package:flutter/material.dart';

import '../../bloc/Model/model.dart';

class MealInfo extends StatelessWidget {
  const MealInfo({
    Key key,
    @required this.mealItem,
  }) : super(key: key);

  final MealItem mealItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        mealItem.mealName,
        style: Theme.of(context).textTheme.subtitle,
      ),
      subtitle: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('P:${mealItem.protein.toStringAsFixed(1)}g ',
                  style:
                      TextStyle(color: Colors.green, fontFamily: 'Questrial')),
              Text('C:${mealItem.carbs.toStringAsFixed(1)}g ',
                  style:
                      TextStyle(color: Colors.blue, fontFamily: 'Questrial')),
              Text('F:${mealItem.fats.toStringAsFixed(1)}g',
                  style: TextStyle(color: Colors.red, fontFamily: 'Questrial'))
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
    );
  }
}
