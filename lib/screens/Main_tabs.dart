import 'package:HIIT/bloc/Model/Macro.dart';

import '../Widgets/Main_Drawer.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import './Tracking.dart';
import './Add_Meal.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import './search.dart';

//import 'package:flutter_radial_menu/flutter_radial_menu.dart';

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
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) =>
        BlocProvider.of<TrackBloc>(context).add(TrackLoadDay(DateTime.now())));

    _routes = [
      {'title': 'Search'},
      {},
      {'title': 'Add Your Meal'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
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
      drawer: MainDrawer(),
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
                items: [AddMeal({}), currentWidget, AddMeal({})],
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
                  Navigator.of(context).pushNamed(Search.routeName);
                },
              ),
            )
          : Text(''),
      bottomNavigationBar: SizedBox(
        height: 56,
        child: CurvedNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          initialIndex: 1,
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
        ),
      ),
    );
  }
}
