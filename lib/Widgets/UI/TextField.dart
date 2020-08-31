import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Map<String, dynamic> props;
  final Function onChange;

  CustomTextField({this.props, this.onChange});

  @override
  Widget build(BuildContext context) {
    print(props);
    final initialValue =
        props['initialValue'] == null ? '' : props['initialValue'];
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Container(
                width: 120,
                child: Text(props['label'],
                    style: Theme.of(context).textTheme.subtitle),
              ),
              Container(
                width: 200,
                child: TextFormField(
                  initialValue: initialValue.toString(),
                  keyboardType: props['keyboard'],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                      hintText: props['placeholder']),
                  validator: props['validator'],
                  style: Theme.of(context).textTheme.caption,
                  onChanged: (value) {
                    onChange(value);
                  },
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
        Divider()
      ],
    );
  }
}
