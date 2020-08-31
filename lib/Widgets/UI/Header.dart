import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;

  Header(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Container(
          child: Text(
            title,
            style: Theme.of(context).textTheme.subhead,
          ),
          padding: EdgeInsets.all(10),
        ),
        elevation: 2,
      ),
    );
  }
}
