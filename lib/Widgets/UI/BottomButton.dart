import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  const BottomButton(@required this.cb, @required this.text);
  final Function cb;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: RaisedButton(
          color: Theme.of(context).primaryColor,
          onPressed: () {
            cb();
          },
          child: Text('Add Meal',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Questrial'))),
    );
  }
}
