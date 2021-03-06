import 'package:HIIT/Widgets/UI/Skeleton.dart';
import 'package:HIIT/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/Model/model.dart';

class Calorie extends StatelessWidget {
  final bool isInverse;
  final Macro macrosConsumed;
  Calorie(this.isInverse, this.macrosConsumed);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalBloc, GoalState>(builder: (context, state) {
      if (state is GoalSuccess) {
        final goals = state.activeGoal;
        print(goals.protein);
        final consumedPercentage =
            macrosConsumed.getCalories / goals.getCalories;
        return LayoutBuilder(
          builder: (ctx, cons) => Container(
            margin: EdgeInsets.symmetric(
                vertical: 0, horizontal: cons.maxWidth * 0.05),
            padding: EdgeInsets.only(top: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      color: Color(0xFF00E5FF) ,
                      height: 1,
                    ),
                    Container(
                      width: cons.maxWidth * consumedPercentage,
                      color: Colors.blueAccent,
                      height: 1,
                    )
                  ],
                ),
                Text(isInverse
                    ? 'Calories Consumed: ${(macrosConsumed.getCalories).toStringAsFixed(2)}'
                    : 'Calories Remaining: ${(goals.getCalories - macrosConsumed.getCalories).toStringAsFixed(2)}')
              ],
            ),
          ),
        );
      }
      return Skeleton(
        height: 20,
        width: double.infinity,
      );
    });
  }
}
