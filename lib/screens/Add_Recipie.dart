import 'package:HIIT/Widgets/Meal/MealItemDismissiable.dart';
import 'package:HIIT/Widgets/MealInformation/MacrosSlim.dart';
import 'package:HIIT/Widgets/MealInformation/MealItemSlimDetails.dart';
import 'package:HIIT/bloc/Model/MealItem.dart';
import 'package:HIIT/bloc/bloc.dart';
import 'package:HIIT/inputs/add-recipie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Widgets/Meal/QtyInput.dart';
import '../Widgets/UI/BottomButton.dart';
import '../Widgets/UI/Header.dart';
import '../Widgets/UI/TextField.dart';
import '../Widgets/UI/bottomModalSheet.dart';
import '../bloc/Model/model.dart';
import '../screens/meal_preview.dart';
import '../screens/search.dart';

class AddRecipieWidget extends StatefulWidget {
  static const routeName = '/add-recipie';

  @override
  _AddRecipieWidgetState createState() => _AddRecipieWidgetState();
}

class _AddRecipieWidgetState extends State<AddRecipieWidget> {
  Map<String, dynamic> _recipieName = createRecipie();
  final _form = GlobalKey<FormState>();
  var isInit = true;
  var recipieId = '';
  var servingSize = 1.0;
  MealGroupName oldGroupName;
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
      final _oldGroupName = args['groupName'];
      groupName =
          _oldGroupName != null ? _oldGroupName : MealGroupName.BreakFast;
      oldGroupName = _oldGroupName;
      BlocProvider.of<RecipieBloc>(context)
          .add(LoadRecipieMeals(args['recipieId']));
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

  Widget _createInputs(String text, Recipie recipie) {
    _recipieName['initialValue'] =
        recipie.recipeMeal != null ? recipie.recipeMeal : '';
    return buildExpanend(
        Text(text),
        Form(
          key: _form,
          child: CustomTextField(
            isEditMode: true,
            props: _recipieName,
            onChange: (val) {
              setState(() {
                _recipieName['value'] = val;
              });
            },
            onSubmited: (val) {
              if (mode == RecipieMode.Edit && val != '')
                BlocProvider.of<RecipieBloc>(context)
                    .add(UpdateRecipieName(val));
            },
          ),
        ),
        20);
  }

  void _changeGroup() {
    bottomModalSheet(
        items: MealGroupName.values,
        cb: (e) => setState(() {
              groupName = e;
            }),
        splitPart: '.',
        context: context);
  }

  Widget _addInputs(Recipie recipie) {
    return buildExpanend(
        Expanded(
            child: GestureDetector(
          onTap: _changeGroup,
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
        )),
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => Dialog(child: QtyInput())).then((value) {
              if (value == null) return;

              setState(() {
                if (double.parse(value) > 0.0)
                  servingSize = double.parse(value);
              });
            });
          },
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Theme.of(context).primaryColorLight),
            child: Text('$servingSize Serving(s)'),
          ),
        ),
        20);
  }

  List<Widget> _buildInputs(RecipieLoadSuccess state) {
    var text = "";
    final recipie = state.recipie;
    Widget inputs = _createInputs(text, recipie);
    switch (mode) {
      case RecipieMode.Add:
        text = "Track the recipie";
        inputs = _addInputs(recipie);
        break;
      case RecipieMode.Create:
        text = "Name your Recipie";
        break;
      case RecipieMode.Edit:
        text = "Edit your Recipie";
        break;
    }
    return [Header(text), inputs];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(mode == RecipieMode.Add
              ? 'Add your recipie'
              : mode == RecipieMode.Create
                  ? "Create your recipie"
                  : "Edit Recipie"),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                    mode == RecipieMode.Create ? Icons.save : Icons.delete),
                color: Colors.white,
                iconSize: 35,
                enableFeedback: true,
                onPressed: () {
                  if (mode == RecipieMode.Create)
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
            if (mode == RecipieMode.Edit || mode == RecipieMode.Add)
              IconButton(
                  icon:
                      Icon(mode == RecipieMode.Edit ? Icons.clear : Icons.edit),
                  onPressed: () {
                    setState(() {
                      mode = mode == RecipieMode.Edit
                          ? RecipieMode.Add
                          : RecipieMode.Edit;
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
            if (state is RecipieDeleteSuccess) Navigator.of(context).pop();
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
                    calories: mode == RecipieMode.Edit
                        ? macros.getCalories
                        : macros.getCalories * servingSize,
                    carbs: mode == RecipieMode.Edit
                        ? macros.carbs
                        : macros.carbs * servingSize,
                    fats: mode == RecipieMode.Edit
                        ? macros.fats
                        : macros.fats * servingSize,
                    protein: mode == RecipieMode.Edit
                        ? macros.protein
                        : macros.protein * servingSize,
                  ),
                  Divider(),
                  ...meals
                      .map((e) => mode == RecipieMode.Edit
                          ? GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    MealPreview.routeName,
                                    arguments: {
                                      "meal": e,
                                      "origin": MealOrigin.Recipie
                                    });
                              },
                              child: DismissiableMeal(
                                mealItem: e,
                                canDismiss: meals.length != 1,
                              ),
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
        floatingActionButton:
            mode == RecipieMode.Create || mode == RecipieMode.Edit
                ? Card(
                    shape: CircleBorder(
                        side: BorderSide(width: 0.5, color: Colors.black54)),
                    elevation: 3,
                    child: IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).pushNamed(Search.routeName,
                              arguments: MealOrigin.Recipie);
                        }),
                  )
                : null,
        bottomNavigationBar: mode == RecipieMode.Add
            ? BlocBuilder<RecipieBloc, RecipieState>(
                builder: (context, state) {
                  if (state is RecipieLoadSuccess) {
                    final macros = state.recipie.macrosConsumed;
                    return BottomButton(() {
                      final recipieToAdd = MealItem(
                          servingName: 'Serving(s)',
                          servingSize: servingSize,
                          carbs: servingSize * macros.carbs,
                          protein: servingSize * macros.protein,
                          fats: servingSize * macros.fats,
                          mealName: state.recipie.recipeMeal,
                          origin: MealOrigin.Recipie,
                          id: recipieId);

                      BlocProvider.of<TrackBloc>(context).add(
                          TrackAddMeal(recipieToAdd, groupName, oldGroupName));
                      Navigator.of(context).pop();
                    }, 'Add Recipie');
                  }
                  return Text('');
                },
              )
            : null);
  }
}
