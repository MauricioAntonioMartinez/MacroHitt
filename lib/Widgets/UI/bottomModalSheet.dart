import 'package:flutter/material.dart';

void bottomModalSheet(
    {List<dynamic> items,
    Function cb,
    String splitPart,
    BuildContext context}) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: items
              .map((i) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    cb(i);
                  },
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8),
                          child: Text(
                            i.toString().split(splitPart)[1],
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        Container(width: double.infinity, child: Divider())
                      ],
                    ),
                  )))
              .toList(),
        ),
      );
    },
  );
}

Widget buildExpanend(Widget a, Widget b, [double horizontalMargin = 0.0]) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 0),
    child: Row(
      children: <Widget>[a, Spacer(), b],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    ),
  );
}
