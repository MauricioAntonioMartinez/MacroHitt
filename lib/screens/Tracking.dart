import 'package:HIIT/Widgets/Vectors/NoTrack.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../Widgets/MealInformation/MacrosMain.dart';
import '../Widgets/Track/MealGroup.dart';
import '../bloc/Model/model.dart';

class Tracking extends StatelessWidget {
  final Map<MealGroupName, List<MealItem>> meals;
  final Macro macrosConsumed;

  Tracking({this.macrosConsumed, this.meals});

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
              Macros(macrosConsumed: macrosConsumed, isInverse: true),
              Macros(macrosConsumed: macrosConsumed, isInverse: false),
            ],
          ),
          isTrackDayEmpty
              ? NoTrack()
              : Expanded(
                  child: ListView.builder(
                      itemBuilder: (ctx, i) {
                        var groupName = meals.keys.toList()[i];
                        return MealGroup(meals[groupName], groupName);
                      },
                      itemCount: meals.length)),
        ],
      ),
    );
  }
}
