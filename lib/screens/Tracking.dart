import 'package:flutter/material.dart';
import '../bloc/Model/model.dart';
import '../Widgets/Meals.dart';
import '../Widgets/Controls/Macros.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Tracking extends StatefulWidget {
  final String date;
  final Map<MealGroupName, List<MealItem>> meals;
  final Macro macroTarget;
  Tracking({this.date, this.macroTarget, this.meals});
  @override
  _Tracking createState() => _Tracking();
}

class _Tracking extends State<Tracking> {
  var meals;

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                  goals: widget.macroTarget,
                  consumed: Macro(30, 23, 55),
                  isInverse: true),
              Macros(
                  goals: widget.macroTarget,
                  consumed: Macro(30, 23, 55),
                  isInverse: false),
            ],
          ),
          Expanded(
              child: ListView.builder(
                  itemBuilder: (ctx, i) {
                    var groupName = widget.meals.keys.toList()[i];
                    return MealWidget(widget.meals[groupName], groupName);
                  },
                  itemCount: widget.meals.length)),
        ],
      ),
    );
  }
}
