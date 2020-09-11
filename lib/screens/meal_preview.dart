import 'package:HIIT/Widgets/Meal/QtyInput.dart';
import 'package:HIIT/Widgets/Vectors/NoMeals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Widgets/Actions/PreviewActions.dart';
import '../Widgets/MealInformation/MacrosSlim.dart';
import '../Widgets/MealInformation/MealItemFullDetails.dart';
import '../Widgets/UI/BottomButton.dart';
import '../Widgets/UI/bottomModalSheet.dart';
import '../bloc/Model/model.dart';
import '../bloc/bloc.dart';
import '../inputs/mealPreview.dart';

class MealPreview extends StatefulWidget {
  static const routeName = '/meal-preview';

  @override
  _MealPreviewState createState() => _MealPreviewState();
}

class _MealPreviewState extends State<MealPreview> {
  final newQtyController = TextEditingController();
  MealGroupName groupName;
  MealItem meal;
  var isDeleted = false;
  MealOrigin origin;
  var isTrack = false;
  Map mealSelected;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isDeleted) {
      mealSelected = ModalRoute.of(context).settings.arguments;
      meal = mealSelected['meal'];
      origin = mealSelected['origin'];
      List<MealItem> meals;
      switch (meal.origin) {
        case MealOrigin.Search:
          meals = (BlocProvider.of<MealBloc>(context).state as MealLoadSuccess)
              .myMeals;
          groupName = MealGroupName.BreakFast;
          break;
        case MealOrigin.Recipie:
          meals = (BlocProvider.of<RecipieBloc>(context).state
                  as RecipieLoadSuccess)
              .recipie
              .meals;
          break;
        case MealOrigin.Track:
          isTrack = true;
          meals =
              (BlocProvider.of<TrackBloc>(context).state as TrackLoadDaySuccess)
                  .trackDay
                  .meals[mealSelected['groupName']];
          groupName = mealSelected['groupName'];
          break;
      }

      if (meals != null) {
        final mealFetched =
            meals.firstWhere((e) => e.id == meal.id, orElse: () => null);
        if (mealFetched != null)
          meal = MealItem(
              origin: mealFetched.origin,
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
  }

  void _changeGroupName() {
    bottomModalSheet(
        items: MealGroupName.values,
        cb: (e) => setState(() {
              groupName = e;
            }),
        splitPart: '.',
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> mealDetails;
    if (meal != null) mealDetails = mealPreviewDetails(meal, context);

    return Scaffold(
      body: meal == null
          ? NoMeals()
          : Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    PreviewActions(
                        onChangeGroupName: _changeGroupName,
                        origin: origin,
                        groupName: groupName,
                        meal: meal,
                        isTrack: isTrack),
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
                    MealItemFullDetails(mealDetails: mealDetails),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomButton(() {
        switch (origin) {
          case MealOrigin.Recipie:
            BlocProvider.of<RecipieBloc>(context).add(AddEditMealRecipie(meal));
            break;
          case MealOrigin.Track:
            BlocProvider.of<TrackBloc>(context)
                .add(TrackAddMeal(meal, groupName, mealSelected['groupName']));
            break;
          default:
            break;
        }
        Navigator.of(context).pop();
      }),
    );
  }
}
