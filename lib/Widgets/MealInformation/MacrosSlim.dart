import 'package:flutter/material.dart';

class MacrosSlim extends StatelessWidget {
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  MacrosSlim({this.calories, this.protein, this.carbs, this.fats});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              '${calories.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 22),
            ),
            Text('CALORIES',
                style: TextStyle(fontSize: 16, fontFamily: 'Questrial'))
          ],
        ),
        Column(
          children: <Widget>[
            Text('${protein.toStringAsFixed(1)}g',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontFamily: 'Questrial')),
            Text('PROTEIN',
                style: TextStyle(fontSize: 16, fontFamily: 'Questrial'))
          ],
        ),
        Column(
          children: <Widget>[
            Text('${carbs.toStringAsFixed(1)}g',
                style: TextStyle(
                    fontSize: 22, color: Colors.blue, fontFamily: 'Questrial')),
            Text('CARBS',
                style: TextStyle(fontSize: 16, fontFamily: 'Questrial'))
          ],
        ),
        Column(
          children: <Widget>[
            Text('${fats.toStringAsFixed(1)}g',
                style: TextStyle(
                    fontSize: 22, color: Colors.red, fontFamily: 'Questrial')),
            Text('FATS',
                style: TextStyle(fontSize: 16, fontFamily: 'Questrial'))
          ],
        ),
      ],
    );
  }
}
