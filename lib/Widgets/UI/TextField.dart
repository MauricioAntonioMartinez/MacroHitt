import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Map<String, dynamic> props;
  final Function onChange;
  final Function onSubmited;
  final bool isEditMode;

  CustomTextField(
      {@required this.props,
      @required this.onChange,
      @required this.onSubmited,
      this.isEditMode});

  @override
  Widget build(BuildContext context) {
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
                    style: Theme.of(context).textTheme.subtitle2),
              ),
              Container(
                width: 200,
                child: !isEditMode
                    ? Text(
                        initialValue.toString(),
                        style: Theme.of(context).textTheme.caption,
                      )
                    : TextFormField(
                        initialValue: initialValue.toString(),
                        keyboardType: props['keyboard'],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.all(8),
                            hintText: props['placeholder']),
                        validator: props['validator'],
                        style: Theme.of(context).textTheme.caption,
                        onChanged: onChange,
                        onFieldSubmitted: onSubmited,
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
