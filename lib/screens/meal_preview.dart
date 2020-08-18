import 'package:HIIT/Widgets/meal_view/qty_input.dart';
import 'package:flutter/material.dart';
import '../Widgets/meal_view/macros_slim.dart';
import '../bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/Model/model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Widgets/UI/BottomButton.dart';
import './EditMeal.dart';

class MealPreview extends StatefulWidget {
  static const routeName = '/meal-preview';

  @override
  _MealPreviewState createState() => _MealPreviewState();
}

class _MealPreviewState extends State<MealPreview> {
  final newQtyController = TextEditingController();
  MealGroupName groupName;
  MealItem meal;
  var isTrack = false;
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
      isTrack = true;
      meals = (BlocProvider.of<TrackBloc>(context).state as TrackLoadDaySuccess)
          .trackDay
          .meals[mealSelected['groupName']];
      groupName = mealSelected['groupName'];
    }
    if (meals != null) {
      final mealFetched = meals.firstWhere(
          (e) => e.id == mealSelected['mealId'],
          orElse: () => null);
      if (mealFetched != null)
        meal = MealItem(
            brandName: mealFetched.brandName,
            servingSize: mealFetched.servingSize,
            carbs: mealFetched.carbs,
            protein: mealFetched.protein,
            fats: mealFetched.fats,
            mealName: mealFetched.mealName,
            servingName: mealFetched.servingName,
            fiber: mealFetched.fiber,
            id: mealFetched.id,
            monosaturatedFat: mealFetched.monosaturatedFat,
            polyunsaturatedFat: mealFetched.polyunsaturatedFat,
            saturatedFat: mealFetched.saturatedFat,
            sugar: mealFetched.sugar);
    }
  }

  Widget buildExpanend(Widget a, Widget b) {
    return Row(
      children: <Widget>[a, Spacer(), b],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }

  void bottomModalSheet(List<dynamic> items, Function cb, String splitPart) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items
                .map((i) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      cb(i);
                    },
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            child: Text(
                              i.toString().split(splitPart)[1],
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
              "Saturated Fat":
                  meal.saturatedFat == null ? 0.0 : meal.saturatedFat,
            },
            {
              "Monosaturated Fat":
                  meal.monosaturatedFat == null ? 0.0 : meal.monosaturatedFat,
            },
            {
              "Polyunsaturated Fat": meal.polyunsaturatedFat == null
                  ? 0.0
                  : meal.polyunsaturatedFat
            },
          ],
        },
        {
          "label": "TotalCarbs",
          "value": meal.getCarbs,
          "color": Colors.blue,
          "details": [
            {
              "Sugar": meal.sugar == null ? 0.0 : meal.sugar,
            },
            {
              "Fiber": meal.fiber == null ? 0.0 : meal.fiber,
            },
          ],
        },
        {"label": "Protein", "value": meal.getProtein, 'color': Colors.green},
        {"label": "Sodium", "value": 0},
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
                              bottomModalSheet(
                                  MealGroupName.values,
                                  (e) => setState(() {
                                        groupName = e;
                                      }),
                                  '.');
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
                                        [' .Edit Meal', ' .Delete Meal'],
                                        (value) {
                                      if (value == ' .Edit Meal') {
                                        Navigator.of(context).pushNamed(
                                            EditMeal.routeName,
                                            arguments: meal);
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
                                                    BlocListener<TrackBloc,
                                                        TrackState>(
                                                      listener:
                                                          (context, state) {},
                                                      child: FlatButton(
                                                        child: Text('Yes'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        },
                                                      ),
                                                    ),
                                                    FlatButton(
                                                      child: Text('No',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                    )
                                                  ],
                                                )).then((isDeleted) {
                                          if (isDeleted) {
                                            Navigator.of(context).pop();
                                            isTrack
                                                ? BlocProvider.of<TrackBloc>(
                                                        context)
                                                    .add(TrackRemoveMeal(
                                                        meal.id, groupName))
                                                : BlocProvider.of<MealBloc>(
                                                        context)
                                                    .add(MealDelete(meal.id));
                                          }
                                        });
                                      }
                                    }, '.');
                                  })
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
                              child: Text(meal.mealName,
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
                                              as List<Map<String, double>>)
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
      bottomNavigationBar: BottomButton(() {
        BlocProvider.of<TrackBloc>(context)
            .add(TrackEditMeal(meal, groupName, mealSelected['groupName']));
        Navigator.of(context).pop();
      }),
    );
  }
}
