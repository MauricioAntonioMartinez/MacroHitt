import 'package:flutter/material.dart';

class AddMeal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> _mealInfo = [
      {'label': 'Meal Name', 'placeholder': 'Eggs ...'},
      {'label': 'Brand Name', 'placeholder': 'San Juan ...'},
      {'label': 'Serving Size', 'placeholder': '100'},
      {'label': 'Serving Name', 'placeholder': 'grams'},
    ];
    final List<Map<String, Object>> _macros = [
      {'label': 'Protein', 'placeholder': '80g', 'keyboard': 'number'},
      {'label': 'Carbs', 'placeholder': '20g', 'keyboard': 'number'},
      {'label': 'Fats', 'placeholder': '5g', 'keyboard': 'number'},
    ];

    return Container(
      padding: EdgeInsets.only(bottom: 30, top: 10, right: 10, left: 10),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.all(10),
              child: Container(
                child: Text(
                  'Meal Info',
                  style: Theme.of(context).textTheme.subhead,
                ),
                padding: EdgeInsets.all(10),
              ),
              elevation: 2,
            ),
          ),
          ..._mealInfo.map((e) => Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 120,
                          child: Text(e['label'],
                              style: Theme.of(context).textTheme.subtitle),
                        ),
                        Container(
                          width: 200,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8),
                                hintText: e['placeholder']),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    ),
                  ),
                  Divider()
                ],
              )),
          Container(
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.all(10),
              child: Container(
                child: Text(
                  'Macros',
                  style: Theme.of(context).textTheme.subhead,
                ),
                padding: EdgeInsets.all(10),
              ),
              elevation: 2,
            ),
          ),
          ..._macros.map((e) => Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 120,
                          child: Text(e['label'],
                              style: Theme.of(context).textTheme.subtitle),
                        ),
                        Container(
                          width: 200,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8),
                                hintText: e['placeholder']),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    ),
                  ),
                  Divider()
                ],
              )),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: FlatButton(
                child: Text('Add meal',
                    style: Theme.of(context).textTheme.subtitle),
                onPressed: () {},
              ))
        ],
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      ),
    );
  }
}
