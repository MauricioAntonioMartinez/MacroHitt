import 'package:flutter/material.dart';
import '../bloc/Model/model.dart';
import '../Widgets/Meals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Widgets/Controls/Macros.dart';
import '../bloc/Track/track_bloc.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

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
                    String grpName;
                    var groupName = widget.meals.keys.toList()[i];
                    if (groupName == MealGroupName.BreakFast) {
                      grpName = 'BreakFast';
                    } else if (groupName == MealGroupName.Dinner) {
                      grpName = 'Dinner';
                    } else if (groupName == MealGroupName.Lunch) {
                      grpName = 'Lunch';
                    } else if (groupName == MealGroupName.Snack) {
                      grpName = 'Snack';
                    }
                    return MealWidget(widget.meals[groupName], grpName);
                  },
                  itemCount: widget.meals.length)),
        ],
      ),
    );
  }
}
