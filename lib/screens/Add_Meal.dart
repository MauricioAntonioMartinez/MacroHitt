import 'package:flutter/material.dart';
import '../bloc/Model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';

class AddMeal extends StatefulWidget {
  @override
  _AddMealState createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  List<Map<String, dynamic>> _mealInfo = [];
  List<Map<String, dynamic>> _macros = [];
  Map<String, dynamic> newMeal = {};
  final _form = GlobalKey<FormState>();
  static String _numberValidator(String value) {
    if (value.trim().isEmpty) {
      return 'Field required';
    } else if (double.tryParse(value) == null)
      return 'Invalid input';
    else if (double.tryParse(value) < 0) return 'Must be positive';
    return null;
  }

  static String _textValidator(String value) {
    if (value.isEmpty) {
      return 'Field required';
    } else if (value.length < 5) return 'Value too short';
    return null;
  }

  void saveForm() {
    final isValid = _form.currentState.validate();
    print(isValid);
    if (isValid) {
      _form.currentState.save();
      print(newMeal);
      final servingSize = double.parse(newMeal['servingSize']);
      final thisMeal = MealItem(
          mealName: newMeal['mealName'],
          carbs: double.parse(newMeal['carbs']) / servingSize,
          fats: double.parse(newMeal['fats']) / servingSize,
          protein: double.parse(newMeal['protein']) / servingSize,
          servingName: newMeal['servingName'],
          servingSize: 1,
          id: DateTime.now().toString());
      BlocProvider.of<MealBloc>(context).add(MealAdd(thisMeal));
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text('Successfully Added'),
      ));
      // Navigator.of(context).pop();
      _form.currentState.reset();
    }
  }

  @override
  void initState() {
    super.initState();
    _mealInfo = [
      {
        'field': 'mealName',
        'label': 'Meal Name',
        'placeholder': 'Eggs ...',
        'validator': _textValidator,
        'keyboard': TextInputType.text,
      },
      {
        'field': 'brandName',
        'label': 'Brand Name',
        'placeholder': 'San Juan ...',
        'validator': _textValidator,
        'keyboard': TextInputType.text,
      },
      {
        'field': 'servingSize',
        'label': 'Serving Size',
        'placeholder': '100',
        'validator': _numberValidator,
        'keyboard': TextInputType.number,
      },
      {
        'field': 'servingName',
        'label': 'Serving Name',
        'placeholder': 'grams',
        'validator': _textValidator,
        'keyboard': TextInputType.text,
      },
    ];
    _macros = [
      {
        'field': 'protein',
        'label': 'Protein',
        'placeholder': '80g',
        'validator': _numberValidator,
        'keyboard': TextInputType.number,
      },
      {
        'field': 'carbs',
        'label': 'Carbs',
        'placeholder': '20g',
        'keyboard': TextInputType.number,
        'validator': _numberValidator,
      },
      {
        'field': 'fats',
        'label': 'Fats',
        'placeholder': '5g',
        'keyboard': TextInputType.number,
        'validator': _numberValidator,
      },
    ];
  }

  Widget buildTextField(Map e) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Container(
                width: 120,
                child: Text(e['label'],
                    style: Theme.of(context).textTheme.subtitle),
              ),
              Container(
                width: 200,
                child: TextFormField(
                  keyboardType: e['keyboard'],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                      hintText: e['placeholder']),
                  validator: e['validator'],
                  style: Theme.of(context).textTheme.caption,
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      newMeal[e['field']] = value;
                    });
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

  Widget buildHeader(String title) {
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Container(
        padding: EdgeInsets.only(bottom: 30, top: 10, right: 10, left: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildHeader('Meal Info'),
                  ..._mealInfo.map((e) => buildTextField(e)),
                  buildHeader('Macros'),
                  ..._macros.map((e) => buildTextField(e)),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            Spacer(),
            Container(
                width: double.infinity,
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: FlatButton(
                  child: Text('Add meal',
                      style: Theme.of(context).textTheme.subtitle),
                  onPressed: () {
                    saveForm();
                  },
                ))
          ],
        ),
      ),
    );
  }
}
