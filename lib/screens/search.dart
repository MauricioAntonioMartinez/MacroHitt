import 'dart:io';

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
                itemBuilder: (context, i) => MealItemWidget(meals[i]),
                itemCount: meals.length,
              )
            : Center(
                child: SvgPicture.asset(
                  'assets/vectors/404.svg',
                  width: 300,
                ),
              )
        // Stack(
        //     children: <Widget>[
        //       Align(
        //         alignment: Alignment.topCenter,
        //         child: ClipPath(
        //           clipper: BackgroundClipper(),
        //           child: Hero(
        //             tag: 'background',
        //             child: Container(
        //               width: MediaQuery.of(context).size.width,
        //               height:
        //                   MediaQuery.of(context).size.width * 0.7 * 1.33,
        //               decoration: BoxDecoration(
        //                 gradient: LinearGradient(
        //                   colors: [
        //                     Theme.of(context).primaryColorDark,
        //                     Theme.of(context).primaryColorLight
        //                   ],
        //                   begin: Alignment.topRight,
        //                   end: Alignment.bottomLeft,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //       Align(
        //         alignment: Alignment.topCenter,
        //         child: Padding(
        //           padding: EdgeInsets.only(
        //               top: MediaQuery.of(context).size.width * 0.8 * 0.5),
        //           child: Hero(
        //             tag: 'image_hero',
        //             child: Column(
        //               children: <Widget>[
        //                 Text(
        //                   'No meal not found ',
        //                   style: TextStyle(fontSize: 35),
        //                 ),
        //                 Icon(
        //                   Icons.not_interested,
        //                   size: 120,
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   )
        );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var roundnessFactor = 50.0;

    var path = Path();

    path.moveTo(0, size.height * 0.33);
    path.lineTo(0, size.height);
    // path.quadraticBezierTo(0, size.height, roundnessFactor, size.height);
    path.lineTo(size.width - roundnessFactor, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - roundnessFactor * 2);
    path.lineTo(size.width, roundnessFactor * 0.5);
    // path.quadraticBezierTo(size.width - 10, roundnessFactor,
    //     size.width - roundnessFactor * 1.5, roundnessFactor * 1.5);
    path.lineTo(roundnessFactor * 0.6, roundnessFactor * 2.25);
    // path.quadraticBezierTo(
    //     0, size.height * 0.33, 0, size.height * 0.33 + roundnessFactor);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
