import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoTrack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 3,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Text(
                'Start Tracking Now',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.body2,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: SvgPicture.asset(
                'assets/vectors/noTrack.svg',
                width: 150,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                width: 220,
                child: Text(
                  'Open the side drawer to start loggin your first food of the day',
                  textAlign: TextAlign.justify,
                ))
          ],
        ),
        height: 300,
      ),
    );
  }
}
