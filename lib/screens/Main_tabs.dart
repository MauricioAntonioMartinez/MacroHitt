import '../Widgets/Main_Drawer.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import './Tracking.dart';
import './Add_Meal.dart';
import './Search_Meal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import './search.dart';

//import 'package:flutter_radial_menu/flutter_radial_menu.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, Object>> _routes;
  int _currentIndex = 1;
  final CarouselController _controller = CarouselController();
  @override
  void initState() {
    _routes = [
      {"page": SearchMeal(), 'title': 'Search'},
      {"page": Tracking(), 'title': 'Track Your Meal'},
      {"page": AddMeal(), 'title': 'Add Your Meal'},
    ];

    super.initState();
  }
  // title: Text(_routes[_currentIndex]['title']),

  Widget _searchMeal(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {},
        )
      ],
      title: TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(8),
          hintText: 'eggs ...',
        ),
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(_routes[_currentIndex]['title']),
      ),
      drawer: MainDrawer(),
      body: BlocBuilder<MealBloc, MealState>(
        builder: (context, state) {
          if (state is MealLoadSuccess) {
            //print(state.myMeals);
            //  BlocProvider.of<MealBloc>(context).add(MealLoad());
          }
          return BlocConsumer<TrackBloc, TrackState>(
            builder: (context, state) {
              //print(state);
              Widget currentWidget;
              if (state is TrackLoading) {
                currentWidget = Center(
                  child: Column(
                    children: <Widget>[
                      Text('Loading'),
                      FlatButton(
                          onPressed: () {
                            BlocProvider.of<TrackBloc>(context)
                                .add(TrackLoadDay(DateTime.now()));
                          },
                          child: Text('ClickMe'))
                    ],
                  ),
                );
              }
              if (state is TrackLoadDaySuccess) {
                currentWidget = Tracking(
                  date: state.date,
                  macroTarget: state.macroTarget,
                  meals: state.meals,
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
                items: [AddMeal(), currentWidget, AddMeal()],
              );
            },
            listener: (context, state) {
              print(state);
              if (state is TrackLoading) {
                BlocProvider.of<TrackBloc>(context)
                    .add(TrackLoadDay(DateTime.now()));
              }
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
          initialIndex: _currentIndex,
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
