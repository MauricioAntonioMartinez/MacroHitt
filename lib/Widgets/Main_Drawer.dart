import 'package:flutter/material.dart';

import '../bloc/Model/model.dart';
import '../screens/Add_Recipe.dart';
import '../screens/search.dart';

class MainDrawer extends StatelessWidget {
  final Function navAction;
  final List<Map<String, Object>> _navegationItems = [
    {'nav': 'Add Meal', 'index': 2},
    {'nav': 'Tracking', 'index': 1},
    {'nav': 'Add Goal', 'index': 0},
    {'nav': 'Search Meal', 'routeName': Search.routeName},
    {
      'nav': 'Add Recipe',
      'routeName': AddRecipeWidget.routeName,
      "arguments": {"mode": RecipeMode.Create}
    },
  ];
  MainDrawer(this.navAction);

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
              color: Theme.of(context).primaryColor,
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
                                onTap: () {
                                  if (e['index'] != null) {
                                    navAction(e['index']);
                                    Navigator.of(context).pop();
                                  } else {
                                    Navigator.of(context)
                                        .pushNamed(e['routeName'],
                                            arguments: e['arguments'])
                                        .then((value) {
                                      Navigator.of(context).pop();
                                    });
                                  }
                                },
                                title: Text(
                                  e['nav'],
                                  style: Theme.of(context).textTheme.subtitle1,
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
