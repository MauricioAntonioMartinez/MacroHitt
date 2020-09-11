import 'package:HIIT/Widgets/Meal/MealItemDismissiable.dart';
import 'package:HIIT/Widgets/MealInformation/MacrosSlim.dart';
import 'package:HIIT/Widgets/MealInformation/MealItemSlimDetails.dart';
import 'package:HIIT/bloc/Model/MealItem.dart';
import 'package:HIIT/bloc/bloc.dart';
import 'package:HIIT/inputs/add-recipie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Widgets/Meal/QtyInput.dart';
import '../Widgets/UI/Header.dart';
import '../Widgets/UI/TextField.dart';
import '../Widgets/UI/bottomModalSheet.dart';
import '../bloc/Model/model.dart';
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
  var servingSize = 1.0;
  MealGroupName groupName = MealGroupName.BreakFast;
  RecipieMode mode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      isInit = false;
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      mode = args['mode'];

      BlocProvider.of<RecipieBloc>(context)
          .add(LoadRecipieMeals(args['recipieId']));

      if (args['recipieId'] != null) {
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

  List<Widget> _buildInputs(RecipieLoadSuccess state) {
    var text = "";
    Widget label = Text(text);

    Widget widgetValue = CustomTextField(
      isEditMode: true,
      props: _recipieName,
      onChange: (val) {
        setState(() {
          _recipieName['value'] = val;
        });
      },
      onSubmited: (val) {
        if (!isNewRecipie && val != '')
          BlocProvider.of<RecipieBloc>(context).add(UpdateRecipieName(val));
      },
    );
    final recipie = state.recipie;

    switch (mode) {
      case RecipieMode.Add:
        text = "Track the recipie";
        label = Expanded(
            child: GestureDetector(
          onTap: () {},
          child: Row(
            children: <Widget>[
              Text(groupName.toString().split('MealGroupName.')[1],
                  style: TextStyle(
                      fontFamily: 'Questrial',
                      fontSize: 18,
                      color: Theme.of(context).primaryColor)),
              Icon(Icons.expand_more)
            ],
          ),
        ));
        widgetValue = GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => Dialog(child: QtyInput())).then((value) {
              if (value == null) return;
              setState(() {
                if (value > 0) servingSize = value;
              });
            });
          },
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Theme.of(context).primaryColorLight),
            child: Text('${recipie.servingSize} Serving(s)'),
          ),
        );
        break;
      case RecipieMode.Create:
        text = "Name your Recipie";
        break;
      case RecipieMode.Edit:
        text = "Edit your Recipie";
        break;
    }
    return [Header(text), buildExpanend(label, widgetValue, 20)];
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
                ..._buildInputs(state),
                Divider(),
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
                        : MealItemSlimDetails(
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
