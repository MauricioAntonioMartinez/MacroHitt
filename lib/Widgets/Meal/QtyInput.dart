import 'package:flutter/material.dart';

class QtyInput extends StatelessWidget {
  final _newQtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          color: Theme.of(context).primaryColor,
          child:
              Text('New Quantity', style: Theme.of(context).textTheme.subhead),
        ),
        Container(
          width: 100,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Center(
              child: TextField(
            onSubmitted: (value) {
              Navigator.of(context, rootNavigator: true).pop(value);
            },
            controller: _newQtyController,
            autofocus: true,
            decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(8),
                hintText: '00.00'),
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.caption,
          )),
        ),
        Row(
          children: <Widget>[
            FlatButton(
                child: Text('Add'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .pop(_newQtyController.text);
                }),
            FlatButton(
                child: Text('Dismiss'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(null);
                })
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        )
      ],
    );
  }
}
