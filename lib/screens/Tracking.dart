import 'package:HIIT/Widgets/NoTrack.dart';
import 'package:flutter/material.dart';
import '../bloc/Model/model.dart';
import '../Widgets/Meals.dart';
import '../Widgets/Controls/Macros.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Tracking extends StatelessWidget {
  final Map<MealGroupName, List<MealItem>> meals;
  final Macro macrosConsumed;
  final Macro goals;
  Tracking({this.macrosConsumed, this.meals, this.goals});

  @override
  Widget build(BuildContext context) {
    final isTrackDayEmpty = meals.keys.length == 0;
    return Center(
      heightFactor: 1,
      child: Column(
        mainAxisSize: isTrackDayEmpty ? MainAxisSize.max : MainAxisSize.min,
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              height: 130,
              autoPlay: false,
              viewportFraction: 0.9,
              enableInfiniteScroll: false,
              enlargeCenterPage: false,
            ),
            items: [
              Macros(
                  goals: goals,
                  macrosConsumed: macrosConsumed,
                  isInverse: true),
              Macros(
                  goals: goals,
                  macrosConsumed: macrosConsumed,
                  isInverse: false),
            ],
          ),
          isTrackDayEmpty
              ? NoTrack()
              : Expanded(
                  child: ListView.builder(
                      itemBuilder: (ctx, i) {
                        var groupName = meals.keys.toList()[i];
                        return MealWidget(meals[groupName], groupName);
                      },
                      itemCount: meals.length)),
        ],
      ),
    );
  }
}
