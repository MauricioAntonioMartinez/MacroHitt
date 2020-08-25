import 'package:flutter/material.dart';
import '../bloc/Model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';
import '../inputs/add-goal.dart';
import '../util/convert.dart';

class AddGoalWidget extends StatefulWidget {
  static const routName = '/add-goal';
  @override
  _AddGoalWidgetState createState() => _AddGoalWidgetState();
}

class _AddGoalWidgetState extends State<AddGoalWidget> {
  List<Map<String, dynamic>> _goalInfo = [{}];
  GoalItem goal;
  var isInit = true;
  var _isEditMode = false;
  var _isDeleted = false;
  Map<String, dynamic> goalInfo = {};
  final _form = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      goal = ModalRoute.of(context).settings.arguments as GoalItem;
      isInit = false;
      if (goal.id != '') {
        _isEditMode = true;
      }
      goalInfo = {
        'id': goal.id,
        'goalName': goal.goalName,
        'protein': goal.protein,
        'carbs': goal.carbs,
        'fats': goal.fats,
      };
      _goalInfo = createGoal(goalInfo);
    }
  }

  void saveForm() {
    final isValid = _form.currentState.validate();

    if (isValid) {
      _form.currentState.save();
      final protein = convertDouble(goalInfo['protein']);
      final carbs = convertDouble(goalInfo['carbs']);
      final fats = convertDouble(goalInfo['fats']);
      final goal = GoalItem(
          goal: Macro(protein, carbs, fats),
          goalName: goalInfo['goalName'],
          id: goalInfo['id']);

      if (_isEditMode) {
        BlocProvider.of<GoalBloc>(context).add(EditGoal(goal));
      } else {
        BlocProvider.of<GoalBloc>(context).add(AddGoal(goal));
        _form.currentState.reset();
      }

      //Navigator.of(context).pop();
    }
  }

  Widget buildTextField(Map e) {
    final initialValue = e['initialValue'] == null ? '' : e['initialValue'];
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Container(
                width: 120,
                child: Text(e['label'],
                    style: Theme.of(context).textTheme.subtitle),
              ),
              Container(
                width: 200,
                child: TextFormField(
                  initialValue: initialValue.toString(),
                  keyboardType: e['keyboard'],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                      hintText: e['placeholder']),
                  validator: e['validator'],
                  style: Theme.of(context).textTheme.caption,
                  onChanged: (value) {
                    setState(() {
                      goalInfo[e['field']] = value;
                    });
                  },
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
        Divider()
      ],
    );
  }

  Widget buildHeader(String title) {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Container(
          child: Text(
            title,
            style: Theme.of(context).textTheme.subhead,
          ),
          padding: EdgeInsets.all(10),
        ),
        elevation: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your goal'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Do you really delete this goal?',
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
                        )).then((isDeleted) {
                  if (isDeleted) {
                    setState(() {
                      _isDeleted = true;
                    });
                    BlocProvider.of<GoalBloc>(context)
                        .add(DeleteGoal(goalInfo['id']));
                  }
                });
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: BlocConsumer<GoalBloc, GoalState>(
            listener: (context, state) {
              if (state is GoalSuccess) {
                if (_isEditMode || _isDeleted) {
                  Navigator.of(context).pushReplacementNamed('/');
                }
                Scaffold.of(context).showSnackBar(SnackBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  content: Text(_isEditMode
                      ? 'Successfully Updated'
                      : 'Successfully Added'),
                ));
              }
              if (state is GoalFailure) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Something went wrong'),
                  backgroundColor: Theme.of(context).errorColor,
                ));
              }
            },
            builder: (context, state) {
              if (state is GoalSuccess) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        buildHeader('Your goals your dreams'),
                        ..._goalInfo.map((e) => buildTextField(e)),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor),
                          child: FlatButton(
                            child: Text(
                                _isEditMode ? 'Update Meal' : 'Start hitt it',
                                style: Theme.of(context).textTheme.subtitle),
                            onPressed: () {
                              saveForm();
                            },
                          )),
                    )
                  ],
                );
              }
              if (state is GoalLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is GoalFailure) {
                return Center(
                  child: Text('Something went wrong'),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
