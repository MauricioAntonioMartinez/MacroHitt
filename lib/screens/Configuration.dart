import 'package:HIIT/screens/Add_goal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';

class Goal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalBloc, GoalState>(builder: (context, state) {
      if (state is GoalSuccess) {
        final goals = state.goals;
        return ListView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                BlocProvider.of<GoalBloc>(context)
                    .add(ToggleActiveGoal(goals[index].id));
              },
              child: Card(
                elevation: 3,
                child: Container(
                  height: 65,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: goals[index].isActive != null
                              ? [
                                  Theme.of(context).primaryColorLight,
                                  Colors.white
                                ]
                              : [Colors.white38, Colors.white],
                          tileMode: TileMode.clamp)),
                  child: ListTile(
                    title: Text(
                      goals[index].goalName,
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('${goals[index].protein}g ',
                            style: TextStyle(color: Colors.green)),
                        Text('${goals[index].carbs}g ',
                            style: TextStyle(color: Colors.blue)),
                        Text('${goals[index].fats}g ',
                            style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    trailing: IconButton(
                        icon: Icon(Icons.arrow_forward),
                        iconSize: 15,
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              AddGoalWidget.routName,
                              arguments: goals[index]);
                        }),
                  ),
                ),
              ),
            );
          },
          itemCount: goals.length,
        );
      }
      if (state is GoalLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
