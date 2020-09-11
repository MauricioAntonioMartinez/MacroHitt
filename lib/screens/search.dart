import 'package:HIIT/Widgets/Vectors/NoMeals.dart';
import 'package:HIIT/bloc/Model/MealItem.dart';
import 'package:HIIT/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Widgets/Track/MealItem.dart';
import '../bloc/meal/meal_bloc.dart';

class Search extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _controller = TextEditingController();
  String matchingName = '';
  List<MealItem> meals = [];
  List<MealItem> searchMeals = [];
  MealOrigin origin;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      origin = ModalRoute.of(context).settings.arguments as MealOrigin;
      final recipieState = BlocProvider.of<RecipieBloc>(context).state;
      final mealsState = BlocProvider.of<MealBloc>(context).state;
      if (recipieState is Recipies) {
        meals = [...recipieState.recipies];
      }
      if (mealsState is MealLoadSuccess) {
        meals = [...meals, ...mealsState.myMeals];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final origin = ModalRoute.of(context).settings.arguments as MealOrigin;
    searchMeals = meals
        .where((meal) =>
            meal.mealName.toLowerCase().contains(matchingName.toLowerCase()))
        .toList();

    return BlocListener<MealBloc, MealState>(
        listener: (context, state) {
          if (state is MealLoadSuccess) {
            setState(() {
              meals = state.myMeals;
            });
          }
        },
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              backgroundColor: Colors.white,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.cancel,
                  ),
                  onPressed: () {
                    _controller.clear();
                  },
                )
              ],
              title: TextFormField(
                controller: _controller,
                autofocus: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                  hintText: 'eggs ...',
                ),
                onChanged: (value) {
                  setState(() {
                    matchingName = value;
                  });
                },
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            body: searchMeals.length > 0
                ? ListView.builder(
                    itemBuilder: (context, i) {
                      return MealItemWidget(meals[i], false, origin);
                    },
                    itemCount: searchMeals.length,
                  )
                : NoMeals()));
  }
}
