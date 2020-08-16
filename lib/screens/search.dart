import 'package:HIIT/bloc/Model/MealItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/meal/meal_bloc.dart';
import '../Widgets/MealItem.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Search extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _controller = TextEditingController();
  String matchingName = '';
  List<MealItem> meals = [];

  @override
  Widget build(BuildContext context) {
    meals = (BlocProvider.of<MealBloc>(context).state as MealLoadSuccess)
        .myMeals
        .where((meal) =>
            meal.mealName.toLowerCase().contains(matchingName.toLowerCase()))
        .toList();

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
        body: meals.length > 0
            ? ListView.builder(
                itemBuilder: (context, i) => MealItemWidget(meals[i], false),
                itemCount: meals.length,
              )
            : Center(
                child: SvgPicture.asset(
                  'assets/vectors/404.svg',
                  width: 300,
                ),
              ));
  }
}
