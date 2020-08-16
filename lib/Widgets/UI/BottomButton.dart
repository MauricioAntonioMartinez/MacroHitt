import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  const BottomButton(this.cb);

  final Function cb;

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
