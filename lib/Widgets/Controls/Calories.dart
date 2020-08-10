import 'package:flutter/material.dart';

class Calorie extends StatelessWidget {
  final bool isInverse;

  Calorie(this.isInverse);

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
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  color: Colors.red,
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  color: Colors.green,
                  height: 0.5,
                )
              ],
            ),
            Text(isInverse
                ? 'Calories Consumed: 00.00'
                : 'Calories Remaining: 00.00')
          ],
        ),
      ),
    );
  }
}
