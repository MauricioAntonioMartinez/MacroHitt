import 'package:HIIT/bloc/bloc.dart';
import 'package:HIIT/bloc/recipie/recipie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/Model/model.dart';
import '../bloc/bloc.dart';
import '../screens/meal_preview.dart';

class MealItemWidget extends StatelessWidget {
  final MealItem mealItem;
  final MealGroupName groupName;
  final bool isDismissible;
  MealItemWidget(this.mealItem, this.isDismissible, [this.groupName]);

  @override
  Widget build(BuildContext context) {
    final Map<DismissDirection, double> dismissThresholds = {
      DismissDirection.vertical: 0.6
    };

    return GestureDetector(
      onTap: () {
        var arguments = {
          "meal": mealItem,
          "groupName": groupName,
        };
        // print(groupName);
        // final isFromRecipie = groupName == null;
        // if (isFromRecipie) {
        //   arguments = {"isFromRecipie": true, "mealId": mealItem.id};
        // }
        Navigator.of(context)
            .pushNamed(MealPreview.routeName, arguments: arguments);
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.symmetric(
                horizontal: BorderSide(color: Colors.white),
                vertical: BorderSide(color: Colors.grey, width: 0.1))),
        child: !isDismissible
            ? MealInfo(mealItem: mealItem)
            : Dismissible(
                key: ValueKey('f'),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) {
                  return showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(
                                'Do you really want to remove this meal?',
                                style: Theme.of(context).textTheme.subtitle),
                            actions: <Widget>[
                              BlocListener<TrackBloc, TrackState>(
                                listener: (context, state) {},
                                child: FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                              ),
                              FlatButton(
                                child: Text('No',
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              )
                            ],
                          )).then((isDeleted) => isDeleted);
                },
                onDismissed: (_) {
                  if (groupName != null) {
                    BlocProvider.of<TrackBloc>(context)
                        .add(TrackRemoveMeal(mealItem.id, groupName));
                  } else {
                    BlocProvider.of<RecipieBloc>(context)
                        .add(DeleteMealRecipie(mealItem.id));
                  }
                },
                dismissThresholds: dismissThresholds,
                background: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  child: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.green,
                      onPressed: null),
                ),
                child: MealInfo(mealItem: mealItem),
              ),
      ),
    );
  }
}

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
