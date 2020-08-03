import '../Widgets/Main_Drawer.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import './Tracking.dart';
import './Add_Meal.dart';
import './Search_Meal.dart';

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
  var _currentIndex = 1;
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  @override
  void initState() {
    _routes = [
      {"page": SearchMeal(), 'title': 'Search'},
      {"page": Tracking(), 'title': 'Track Your Meal'},
      {"page": AddMeal(), 'title': 'Add Your Meal'},
    ];
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _controller.addStatusListener((status) {
    //   // print(status);
    //   if (status == AnimationStatus.reverse) _controller.stop();
    // });
    final appBar = AppBar(
      title: Text(_routes[_currentIndex]['title']),
    );
    final bottomNavigationBar = SizedBox(
      height: 56,
      child: CurvedNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        initialIndex: _currentIndex,
        items: <Widget>[
          Icon(
            Icons.restaurant_menu,
            size: 30,
          ),
          Icon(Icons.calendar_today, size: 30),
          Icon(Icons.add, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );

    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: appBar,
      drawer: MainDrawer(),
      body: SlideTransition(
        position: _offsetAnimation,
        child: _routes[_currentIndex]['page'],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          _routes[_currentIndex]['page'],
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
