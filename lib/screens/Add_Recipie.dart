import 'package:HIIT/Widgets/meal_view/macros_slim.dart';
import 'package:HIIT/bloc/Model/MealItem.dart';
import 'package:HIIT/inputs/add-recipie.dart';
import 'package:flutter/material.dart';
import '../Widgets/UI/Header.dart';
import '../Widgets/UI/TextField.dart';
import '../Widgets/Meals.dart';

class AddRecipieWidget extends StatefulWidget {
  static const routeName = '/add-recipie';

  @override
  _AddRecipieWidgetState createState() => _AddRecipieWidgetState();
}

class _AddRecipieWidgetState extends State<AddRecipieWidget> {
  Map<String, dynamic> _recipieName = createRecipie({'recipieName': ''});
  List<MealItem> meals = [
    MealItem(
        brandName: 'Sime',
        carbs: 23,
        fats: 32,
        mealName: 'Snack',
        protein: 323,
        servingName: '',
        servingSize: 32,
        fiber: 0,
        id: '3')
  ];
  var isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      //goal = ModalRoute.of(context).settings.arguments as Re;
      isInit = false;
      // if (goal.id != '') {
      //   _isEditMode = true;
      // }

      _recipieName = createRecipie({'recipieName': ''});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your recipie'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Header('Name your recipie'),
          CustomTextField(
            props: _recipieName,
            onChange: (val) {
              setState(() {
                _recipieName['value'] = val;
              });
            },
          ),
          MacrosSlim(
            calories: 0,
            carbs: 0,
            fats: 0,
            protein: 0,
          ),
          Divider(),
          MealWidget(meals)
        ],
      )),
      floatingActionButton: Card(
        shape:
            CircleBorder(side: BorderSide(width: 0.5, color: Colors.black54)),
        elevation: 3,
        child: IconButton(
            icon: Icon(Icons.add),
            color: Theme.of(context).primaryColor,
            onPressed: () {}),
      ),
    );
  }
}
