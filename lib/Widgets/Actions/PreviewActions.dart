import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/Model/model.dart';
import '../../bloc/bloc.dart';
import '../../screens/EditMeal.dart';
import '../UI/bottomModalSheet.dart';

class PreviewActions extends StatelessWidget {
  const PreviewActions({
    Key key,
    @required this.origin,
    @required this.groupName,
    @required this.meal,
    @required this.isTrack,
    @required this.onChangeGroupName,
    @required this.didUpdate,
  }) : super(key: key);
  final Function didUpdate;
  final MealOrigin origin;
  final MealGroupName groupName;
  final MealItem meal;
  final bool isTrack;
  final Function onChangeGroupName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        children: <Widget>[
          if (origin != MealOrigin.Recipe)
            Expanded(
                child: GestureDetector(
              onTap: onChangeGroupName,
              child: Row(
                children: <Widget>[
                  Text(groupName.toString().split('MealGroupName.')[1],
                      style: TextStyle(
                          fontFamily: 'Questrial',
                          fontSize: 18,
                          color: Theme.of(context).primaryColor)),
                  Icon(Icons.expand_more)
                ],
              ),
            )),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  size: 22,
                ),
                onPressed: () {},
              ),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 22,
                  ),
                  onPressed: () {
                    bottomModalSheet(
                        items: [' .Edit Meal', ' .Delete Meal'],
                        cb: (value) {
                          if (value == ' .Edit Meal') {
                            Navigator.of(context)
                                .pushNamed(EditMeal.routeName, arguments: meal)
                                .then((mealIsUpdate) {
                              if (mealIsUpdate != null) {
                                didUpdate(mealIsUpdate);
                              }
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text(
                                          'Do you really want to delete this meal?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle),
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
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        )
                                      ],
                                    )).then((isDeleted) {
                              if (isDeleted) {
                                isTrack
                                    ? BlocProvider.of<TrackBloc>(context).add(
                                        TrackRemoveMeal(meal.id, groupName))
                                    : BlocProvider.of<MealBloc>(context)
                                        .add(MealDelete(meal.id));
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        },
                        splitPart: '.',
                        context: context);
                  })
            ],
          )
        ],
        mainAxisAlignment: origin != MealOrigin.Recipe
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
