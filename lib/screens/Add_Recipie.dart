import 'package:HIIT/Widgets/Meal/dismissiable_meal.dart';
import 'package:HIIT/Widgets/Meal/meal_info.dart';
import 'package:HIIT/Widgets/meal_view/macros_slim.dart';
import 'package:HIIT/bloc/Model/MealItem.dart';
import 'package:HIIT/bloc/bloc.dart';
import 'package:HIIT/inputs/add-recipie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Widgets/UI/Header.dart';
import '../Widgets/UI/TextField.dart';
import '../screens/search.dart';

class AddRecipieWidget extends StatefulWidget {
  static const routeName = '/add-recipie';

  @override
  _AddRecipieWidgetState createState() => _AddRecipieWidgetState();
}

class _AddRecipieWidgetState extends State<AddRecipieWidget> {
  Map<String, dynamic> _recipieName = createRecipie({'recipieName': ''});
  final _form = GlobalKey<FormState>();
  var isInit = true;
  var isNewRecipie = true;
  var recipieId = '';
  var isEditMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      recipieId = ModalRoute.of(context).settings.arguments;
      isInit = false;
      BlocProvider.of<RecipieBloc>(context).add(LoadRecipieMeals(recipieId));
      if (recipieId != null) {
        isNewRecipie = false;
        _recipieName = createRecipie({'recipieName': ''});
      }
    }
  }

  void saveForm() {
    final isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      BlocProvider.of<RecipieBloc>(context)
          .add(SaveRecipie(_recipieName['value']));
    }
  }

  @override
  void deactivate() {
    BlocProvider.of<RecipieBloc>(context).add(LoadRecipies());
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isNewRecipie
            ? 'Add your recipie'
            : isEditMode ? "Update your recipie" : "Your Recipie"),
        actions: <Widget>[
          IconButton(
              icon: Icon(isNewRecipie
                  ? Icons.save
                  : isEditMode ? Icons.delete : Icons.edit),
              color: Colors.white,
              iconSize: 35,
              enableFeedback: true,
              onPressed: () {
                if (isNewRecipie)
                  saveForm();
                else
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(
                                'Do you really want to remove this recipie?',
                                style: Theme.of(context).textTheme.subtitle),
                            actions: <Widget>[
                              BlocListener<TrackBloc, TrackState>(
                                listener: (context, state) {},
                                child: FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                              ),
                              FlatButton(
                                child: Text('No',
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              )
                            ],
                          )).then((isDeleted) {
                    if (isDeleted)
                      BlocProvider.of<RecipieBloc>(context)
                          .add(DeleteRecipie(recipieId));
                  });
              }),
          if (isEditMode)
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    isEditMode = true;
                  });
                })
        ],
      ),
      body: BlocConsumer<RecipieBloc, RecipieState>(
        listener: (context, state) {
          if (state is RecipieSavedSuccess) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Saved Successfully'),
              backgroundColor: Theme.of(context).primaryColor,
            ));
            BlocProvider.of<RecipieBloc>(context).add(LoadRecipies());
            Future.delayed(Duration(seconds: 1)).then((_) {
              Navigator.of(context).pop();
            });
          }
          if (state is RecipieDeleteSuccess) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Delete Successfully'),
              backgroundColor: Theme.of(context).primaryColor,
            ));
          }
          if (state is RecipieLoadFailure) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).errorColor,
            ));
          }
        },
        builder: (context, state) {
          if (state is RecipieLoadSuccess) {
            final meals = state.recipie.meals;
            final macros = state.recipie.macrosConsumed;
            return SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Header(isEditMode || isNewRecipie
                    ? 'Name your recipie'
                    : state.recipie.recipeMeal),
                Form(
                  key: _form,
                  child: CustomTextField(
                    //TODO: Switch to name recipie and qty input
                    isEditMode: isEditMode || isNewRecipie,
                    props: _recipieName,
                    onChange: (val) {
                      setState(() {
                        _recipieName['value'] = val;
                      });
                    },
                    onSubmited: (val) {
                      if (!isNewRecipie && val != '')
                        BlocProvider.of<RecipieBloc>(context)
                            .add(UpdateRecipieName(val));
                    },
                  ),
                ),
                MacrosSlim(
                  calories: macros.getCalories,
                  carbs: macros.carbs,
                  fats: macros.fats,
                  protein: macros.protein,
                ),
                Divider(),
                ...meals
                    .map((e) => isEditMode || isNewRecipie
                        ? DismissiableMeal(
                            mealItem: e,
                          )
                        : MealInfo(
                            mealItem: e,
                          ))
                    .toList(),
              ],
            ));
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: Card(
        shape:
            CircleBorder(side: BorderSide(width: 0.5, color: Colors.black54)),
        elevation: 3,
        child: IconButton(
            icon: Icon(Icons.add),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(Search.routeName, arguments: MealOrigin.Recipie);
            }),
      ),
    );
  }
}
