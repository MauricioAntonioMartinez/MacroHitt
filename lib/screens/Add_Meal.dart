import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/Model/model.dart';
import '../bloc/bloc.dart';
import '../inputs/create-meal.dart';

class AddMeal extends StatefulWidget {
  final Map<String, dynamic> mealFields;
  AddMeal(this.mealFields);
  @override
  _AddMealState createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  List<Map<String, dynamic>> _mealInfo = [{}];
  List<Map<String, dynamic>> _macros = [{}];
  List<Map<String, dynamic>> _details = [{}];
  var _isEditMode = false;
  Map<String, dynamic> newMeal = {};
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _mealInfo = mealInfo(widget.mealFields);
    _macros = macros(widget.mealFields);
    _details = details(widget.mealFields);
    _isEditMode = (widget.mealFields.keys.length != 0);
    newMeal = widget.mealFields;
  }

  double convertDouble(dynamic value) => value is double
      ? value
      : double.tryParse(value) == null ? 0 : double.parse(value);

  void saveForm() {
    final isValid = _form.currentState.validate();

    if (isValid) {
      _form.currentState.save();
      final servingSize = convertDouble(newMeal['servingSize']);
      final thisMeal = MealItem(
        id: newMeal['id'],
        origin: newMeal['origin'],
        mealName: newMeal['mealName'],
        brandName: newMeal['brandName'],
        servingName: newMeal['servingName'],
        carbs: convertDouble(newMeal['carbs']) / servingSize,
        fats: convertDouble(newMeal['fats']) / servingSize,
        protein: convertDouble(newMeal['protein']) / servingSize,
        monosaturatedFat: newMeal['monosaturatedFat'] != null
            ? convertDouble(newMeal['monosaturatedFat'])
            : 0,
        polyunsaturatedFat: newMeal['polyunsaturatedFat'] != null
            ? convertDouble(newMeal['polyunsaturatedFat'])
            : 0,
        saturatedFat: newMeal['saturatedFat'] != null
            ? convertDouble(newMeal['saturatedFat'])
            : 0,
        sugar: newMeal['sugar'] != null ? convertDouble(newMeal['sugar']) : 0.0,
        fiber: newMeal['fiber'] != null ? convertDouble(newMeal['fiber']) : 0.0,
        servingSize: 1,
      );

      if (_isEditMode) {
        print(_isEditMode);
        BlocProvider.of<MealBloc>(context).add(MealEdit(thisMeal));
      } else {
        BlocProvider.of<MealBloc>(context).add(MealAdd(thisMeal));
        _form.currentState.reset();
      }

      //Navigator.of(context).pop();
    }
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
                  initialValue: _isEditMode ? e['initialValue'].toString() : '',
                  keyboardType: e['keyboard'],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                      hintText: e['placeholder']),
                  validator: e['validator'],
                  style: Theme.of(context).textTheme.caption,
                  onChanged: (value) {
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
    return SingleChildScrollView(
      child: Form(
        key: _form,
        child: BlocConsumer<MealBloc, MealState>(
          listener: (context, state) {
            if (state is MealLoadSuccess) {
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).primaryColor,
                content: Text(_isEditMode
                    ? 'Successfully Updated'
                    : 'Successfully Added'),
              ));
            }
          },
          builder: (context, state) {
            if (state is MealLoadSuccess) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      buildHeader('Meal Info'),
                      ..._mealInfo.map((e) => buildTextField(e)),
                      buildHeader('Macros'),
                      ..._macros.map((e) => buildTextField(e)),
                      buildHeader('Details (optional)'),
                      ..._details.map((e) => buildTextField(e)),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor),
                        child: FlatButton(
                          child: Text(_isEditMode ? 'Update Meal' : 'Add Meal',
                              style: Theme.of(context).textTheme.subtitle),
                          onPressed: () {
                            saveForm();
                          },
                        )),
                  )
                ],
              );
            }
            if (state is MealLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
