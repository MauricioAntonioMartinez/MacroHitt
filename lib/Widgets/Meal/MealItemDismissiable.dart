import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/Model/model.dart';
import '../../bloc/bloc.dart';
import '../MealInformation/MealItemSlimDetails.dart';

class DismissiableMeal extends StatelessWidget {
  DismissiableMeal({
    Key key,
    @required this.mealItem,
    this.groupName,
    this.canDismiss,
  }) : super(key: key);
  final bool canDismiss;
  final MealGroupName groupName;
  final MealItem mealItem;
  final Map<DismissDirection, double> dismissThresholds = {
    DismissDirection.vertical: 0.6
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
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
                  )).then((isDeleted) {
            if (!canDismiss) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('The recipie cannot be empty !!'),
                backgroundColor: Theme.of(context).errorColor,
              ));
              return false;
            }
            return isDeleted;
          });
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
              icon: Icon(Icons.delete), color: Colors.green, onPressed: null),
        ),
        child: MealItemSlimDetails(mealItem: mealItem),
      ),
    );
  }
}
