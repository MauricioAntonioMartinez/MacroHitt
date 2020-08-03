import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  List<Map<String, Object>> _navegationItems = [
    {'nav': 'Add Meal'},
    {'nav': 'Search Meal'},
    {'nav': 'Tracking'}
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      semanticLabel: 'semeantic',
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColorDark,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Text(
                'Wellcome To MacroHITT',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Questrial',
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 600,
              child: ListView(
                children: <Widget>[
                  ..._navegationItems.map((e) => Container(
                        decoration: BoxDecoration(
                            border: Border(
                                right:
                                    BorderSide(width: 3, color: Colors.black))),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                                title: Text(
                              e['nav'],
                              style: Theme.of(context).textTheme.subhead,
                            )),
                            Divider()
                          ],
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
