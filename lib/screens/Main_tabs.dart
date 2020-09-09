import 'package:HIIT/bloc/Model/GoalItem.dart';
import 'package:HIIT/screens/Add_goal.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import './Add_Meal.dart';
import './Configuration.dart';
import './Tracking.dart';
import './search.dart';
import '../Widgets/Main_Drawer.dart';
import '../bloc/Model/model.dart';
import '../bloc/bloc.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, Object>> _routes;
  int _currentIndex = 1;
  String currentDate = DateFormat.yMMMd().format(DateTime.now());
  final CarouselController _controller = CarouselController();
  GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      // BlocProvider.of<RecipieBloc>(context).add(LoadRecipies());
      BlocProvider.of<TrackBloc>(context).add(TrackLoadDay(DateTime.now()));
    });

    _routes = [
      {'title': 'Pick your goal'},
      {},
      {'title': 'Add Your Meal'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          if (_currentIndex == 0)
            IconButton(
                icon: Icon(Icons.add_circle),
                color: Colors.white,
                iconSize: 40,
                enableFeedback: true,
                onPressed: () {
                  Navigator.of(context).pushNamed(AddGoalWidget.routName,
                      arguments:
                          GoalItem(id: '', goalName: '', goal: Macro(0, 0, 0)));
                })
        ],
        title: GestureDetector(
            onTap: () {
              if (_currentIndex == 1)
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2200))
                    .then((pickedDate) {
                  if (pickedDate == null) return;
                  BlocProvider.of<TrackBloc>(context)
                      .add(TrackLoadDay(pickedDate));
                  setState(() {
                    currentDate = DateFormat.yMMMd().format(pickedDate);
                  });
                });
            },
            child: Text(_currentIndex == 1
                ? currentDate
                : _routes[_currentIndex]['title'])),
      ),
      drawer: MainDrawer((index) {
        setState(() {
          _controller.jumpToPage(index);
          _currentIndex = index;
        });
      }),
      body: BlocBuilder<MealBloc, MealState>(
        builder: (context, state) {
          if (state is MealLoadSuccess) {
            //print(state.myMeals);
            //  BlocProvider.of<MealBloc>(context).add(MealLoad());
          }
          return BlocBuilder<TrackBloc, TrackState>(
            builder: (context, state) {
              //print(state);
              Widget currentWidget;
              if (state is TrackLoading) {
                currentWidget = Center(child: CircularProgressIndicator());
              }
              if (state is TrackLoadDaySuccess) {
                currentWidget = Tracking(
                  macrosConsumed: state.trackDay.macrosConsumed,
                  meals: state.trackDay.meals,
                );
              }
              return CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                  height: maxHeight,
                  initialPage: _currentIndex,
                  onPageChanged: (page, reason) {
                    if (reason == CarouselPageChangedReason.manual) {
                      setState(() {
                        _currentIndex = page;
                      });
                    }
                  },
                  autoPlay: false,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: false,
                ),
                items: [Goal(), currentWidget, AddMeal({})],
              );
            },
          );
        },
      ),
      floatingActionButton: _currentIndex == 1
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Theme.of(context).primaryColor,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(Search.routeName, arguments: MealOrigin.Track);
                },
              ),
            )
          : Text(''),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 15,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          CurvedNavigationBar(
            key: _bottomNavigationKey,
            backgroundColor: Theme.of(context).primaryColor,
            index: _currentIndex,
            items: <Widget>[
              Icon(
                Icons.settings,
                size: 30,
              ),
              Icon(Icons.calendar_today, size: 30),
              Icon(
                Icons.add,
                size: 30,
              ),
            ],
            onTap: (index) {
              _controller.animateToPage(index,
                  duration: Duration(seconds: 1), curve: Curves.easeInOutQuad);
              setState(() {
                _currentIndex = index;
              });
            },
          )
        ],
      ),
    );
  }
}
