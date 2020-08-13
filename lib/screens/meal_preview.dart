import 'package:HIIT/Widgets/meal_view/qty_input.dart';
import 'package:flutter/material.dart';
import '../Widgets/meal_view/macros_slim.dart';
import '../bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/Model/model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MealPreview extends StatefulWidget {
  static const routeName = '/meal-preview';

  @override
  _MealPreviewState createState() => _MealPreviewState();
}

class _MealPreviewState extends State<MealPreview> {
  final newQtyController = TextEditingController();
  MealGroupName groupName;
  MealItem meal;

  Map mealSelected;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mealSelected = ModalRoute.of(context).settings.arguments;
    List<MealItem> meals;
    if (mealSelected['groupName'] == null) {
      meals =
          (BlocProvider.of<MealBloc>(context).state as MealLoadSuccess).myMeals;
      groupName = MealGroupName.BreakFast;
    } else {
      meals = (BlocProvider.of<TrackBloc>(context).state as TrackLoadDaySuccess)
          .meals[mealSelected['groupName']];
      groupName = mealSelected['groupName'];
    }
    if (meals != null)
      meal = meals.firstWhere((e) => e.id == mealSelected['mealId'],
          orElse: () => null);
  }

  Widget buildExpanend(Widget a, Widget b) {
    return Row(
      children: <Widget>[a, Spacer(), b],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }

  void bottomModalSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: MealGroupName.values
                .map((e) => GestureDetector(
                    onTap: () {
                      setState(() {
                        groupName = e;
                        Navigator.of(context).pop();
                      });
                    },
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            child: Text(
                              e.toString().split('MealGroupName.')[1],
                              style: Theme.of(context).textTheme.subtitle,
                            ),
                          ),
                          Container(width: double.infinity, child: Divider())
                        ],
                      ),
                    )))
                .toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> mealDetails;
    if (meal != null)
      mealDetails = [
        {
          "label": "Calories",
          "value": meal.getCalories,
          "color": Theme.of(context).primaryColorDark
        },
        {
          "label": "Total Fats",
          "value": meal.getFats,
          "color": Theme.of(context).errorColor,
          "details": [
            {
              "Saturated Fat": 0,
            },
            {
              "Monosaturated Fat": 0,
            },
            {"Polyunsaturated Fat": 0},
          ],
        },
        {
          "label": "TotalCarbs",
          "value": meal.getCarbs,
          "color": Colors.blue,
          "details": [
            {
              "Sugar": 0,
            },
            {
              "Fiber": 0,
            },
          ],
        },
        {"label": "Protein", "value": meal.getProtein, 'color': Colors.green},
        {"label": "Sodium", "value": 0},
        {"label": "Sugar", "value": 0},
      ];

    return Scaffold(
      body: meal == null
          ? Center(
              child: SvgPicture.asset(
                'assets/vectors/404.svg',
                width: 300,
              ),
            )
          : Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 30,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: GestureDetector(
                            onTap: () {
                              bottomModalSheet();
                            },
                            child: Row(
                              children: <Widget>[
                                Text(
                                    groupName
                                        .toString()
                                        .split('MealGroupName.')[1],
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
                                  Icons.save,
                                  size: 18,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    size: 18,
                                  ),
                                  onPressed: () {})
                            ],
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                    Divider(),
                    buildExpanend(
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Text('Recipie',
                                  style: TextStyle(
                                    color: Colors.black45,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text('Ensalada Rusa',
                                  style: TextStyle(
                                      fontFamily: 'Questrial',
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    Dialog(child: QtyInput())).then((value) {
                              if (value == null) return;
                              final newMeal =
                                  meal.updateServingSize(double.parse(value));
                              setState(() {
                                meal = newMeal;
                              });
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Theme.of(context).primaryColorLight),
                            child:
                                Text('${meal.servingSize} ${meal.servingName}'),
                          ),
                        )),
                    Divider(),
                    MacrosSlim(
                        carbs: meal.carbs,
                        fats: meal.fats,
                        protein: meal.protein,
                        calories: meal.getCalories),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: mealDetails.map((e) {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: buildExpanend(
                                  Text(e['label'],
                                      style: TextStyle(
                                          fontFamily: 'Questrial',
                                          fontSize: 18,
                                          color: e['color'])),
                                  Text('${e['value'].toStringAsFixed(1)} kcal',
                                      style: TextStyle(
                                          fontFamily: 'Questrial',
                                          fontSize: 18,
                                          color: e['color'])),
                                ),
                              ),
                              if (e['details'] != null)
                                Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      children: ((e['details']
                                              as List<Map<String, int>>)
                                          .map((e) {
                                        final key = e.keys.toList()[0];
                                        return buildExpanend(
                                            Text(key), Text(e[key].toString()));
                                      }).toList() as List<Widget>),
                                    )),
                              Divider()
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              BlocProvider.of<TrackBloc>(context).add(
                  TrackEditMeal(meal, groupName, mealSelected['groupName']));
              Navigator.of(context).pop();
            },
            child: Text('Add Meal',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Questrial'))),
      ),
    );
  }
}
