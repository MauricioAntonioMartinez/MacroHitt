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
  MealOrigin origin;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      origin = ModalRoute.of(context).settings.arguments as MealOrigin;
    });
  }

  List<MealItem> _mutateMealsTracks(
      MealState mealState, RecipeState recipesState) {
    List<MealItem> meals;
    if (recipesState is Recipes) {
      meals = [...recipesState.recipes];
    }
    if (mealState is MealLoadSuccess) {
      meals = [...meals, ...mealState.myMeals];
    }
    return meals;
  }

  List<MealItem> _filterMeals(List<MealItem> meals) => meals
      .where((meal) =>
          meal.mealName.toLowerCase().contains(matchingName.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    origin = ModalRoute.of(context).settings.arguments as MealOrigin;
    print(origin);
    return Scaffold(
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
        body: BlocBuilder<MealBloc, MealState>(builder: (context, mealSate) {
          if (mealSate is MealLoadSuccess) {
            return BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, recipeState) {
                if (recipeState is Recipes) {
                  final meals =
                      _filterMeals(_mutateMealsTracks(mealSate, recipeState));
                  if (meals.length == 0) return NoMeals();
                  return ListView.builder(
                    itemBuilder: (context, i) {
                      return MealItemWidget(meals[i], false, origin);
                    },
                    itemCount: meals.length,
                  );
                }
                final meals = _filterMeals(mealSate.myMeals);
                if (meals.length == 0) return NoMeals();
                return ListView.builder(
                  itemBuilder: (context, i) {
                    return MealItemWidget(meals[i], false, origin);
                  },
                  itemCount: meals.length,
                );
              },
            );
          }
          return NoMeals();
        }));
  }
}
