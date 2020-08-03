import 'package:flutter/material.dart';

class Calorie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, cons) => Container(
        margin:
            EdgeInsets.symmetric(vertical: 0, horizontal: cons.maxWidth * 0.05),
        padding: EdgeInsets.only(top: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: double.infinity,
              color: Colors.red,
              height: 1,
            ),
            Text('Calories Consumed: 00.00')
          ],
        ),
      ),
    );
  }
}
