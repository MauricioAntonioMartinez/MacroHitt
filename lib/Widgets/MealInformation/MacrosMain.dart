import 'package:HIIT/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/Model/model.dart';
import '../UI/Skeleton.dart';
import 'Calories.dart';

class Macros extends StatelessWidget {
  final Macro macrosConsumed;
  final bool isInverse;
  Macros({this.macrosConsumed, this.isInverse});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalBloc, GoalState>(
      builder: (context, state) {
        if (state is GoalLoading) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Skeleton(
                  height: 60,
                  width: double.infinity,
                ),
                SizedBox(
                  height: 5,
                ),
                Skeleton(
                  height: 30,
                  width: double.infinity,
                ),
              ],
            ),
          );
        }

        if (state is GoalSuccess) {
          final goals = state.activeGoal;
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.grey, width: 0.5))),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        color: Colors.grey, width: 0.5))),
                            child: Column(children: <Widget>[
                              Text(
                                (isInverse
                                        ? macrosConsumed.protein
                                        : goals.protein -
                                            macrosConsumed.protein)
                                    .toStringAsFixed(1),
                                style: Theme.of(context).textTheme.title,
                              ),
                              Text(
                                'Protein',
                                style: Theme.of(context).textTheme.subtitle,
                              )
                            ]),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        color: Colors.grey, width: 0.5))),
                            child: Column(children: <Widget>[
                              Text(
                                (isInverse
                                        ? macrosConsumed.fats
                                        : goals.fats - macrosConsumed.fats)
                                    .toStringAsFixed(1),
                                style: Theme.of(context).textTheme.title,
                              ),
                              Text(
                                'Fats',
                                style: Theme.of(context).textTheme.subtitle,
                              )
                            ]),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Column(children: <Widget>[
                              Text(
                                (isInverse
                                        ? macrosConsumed.carbs
                                        : goals.carbs - macrosConsumed.carbs)
                                    .toStringAsFixed(1),
                                style: Theme.of(context).textTheme.title,
                              ),
                              Text(
                                'Carbs',
                                style: Theme.of(context).textTheme.subtitle,
                              )
                            ]),
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  Container(
                    child: Calorie(isInverse, macrosConsumed),
                    height: 40,
                  )
                ],
              ),
            ),
          );
        }
        return Skeleton(
          height: 20,
          width: 50,
        );
      },
    );
  }
}
