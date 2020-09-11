import 'package:flutter/material.dart';

import '../UI/bottomModalSheet.dart';

class MealItemFullDetails extends StatelessWidget {
  const MealItemFullDetails({
    Key key,
    @required this.mealDetails,
  }) : super(key: key);

  final List<Map<String, dynamic>> mealDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: mealDetails.map((e) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: buildExpanend(
                  Text(e['label'],
                      style: TextStyle(
                          fontFamily: 'Questrial',
                          fontSize: 18,
                          color: e['color'])),
                  Text('${e['value'].toStringAsFixed(1)} kcal',
                      style: TextStyle(
                          fontFamily: 'Questrial',
                          fontSize: 18,
                          color: e['color'])),
                ),
              ),
              if (e['details'] != null)
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      children:
                          ((e['details'] as List<Map<String, double>>).map((e) {
                        final key = e.keys.toList()[0];
                        return buildExpanend(
                            Text(key), Text(e[key].toString()));
                      }).toList() as List<Widget>),
                    )),
              Divider()
            ],
          );
        }).toList(),
      ),
    );
  }
}
