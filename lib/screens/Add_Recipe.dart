import 'package:HIIT/Widgets/Meal/MealItemDismissiable.dart';
import 'package:HIIT/Widgets/MealInformation/MacrosSlim.dart';
import 'package:HIIT/Widgets/MealInformation/MealItemSlimDetails.dart';
import 'package:HIIT/bloc/Model/MealItem.dart';
import 'package:HIIT/bloc/bloc.dart';
import 'package:HIIT/inputs/add-recipe.dart';
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

class AddRecipeWidget extends StatefulWidget {
  static const routeName = '/add-recipe';

  @override
  _AddRecipeWidgetState createState() => _AddRecipeWidgetState();
}

class _AddRecipeWidgetState extends State<AddRecipeWidget> {
  Map<String, dynamic> _recipeName = createRecipe();
  final _form = GlobalKey<FormState>();
  var isInit = true;
  var recipeId = '';
  var servingSize = 1.0;
  MealGroupName oldGroupName;
  MealGroupName groupName = MealGroupName.BreakFast;
  RecipeMode mode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      isInit = false;
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      mode = args['mode'];

      servingSize = args['servingSize'] == null ? 1.0 : args['servingSize'];

      final _oldGroupName = args['groupName'];
      groupName =
          _oldGroupName != null ? _oldGroupName : MealGroupName.BreakFast;
      oldGroupName = _oldGroupName;
      BlocProvider.of<RecipeBloc>(context)
          .add(LoadRecipeMeals(args['recipeId']));
    }
  }

  void saveForm() {
    final isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      BlocProvider.of<RecipeBloc>(context)
          .add(SaveRecipe(_recipeName['value']));
    }
  }

  @override
  void deactivate() {
    BlocProvider.of<RecipeBloc>(context).add(LoadRecipes());
    super.deactivate();
  }

  Widget _createInputs(String text, Recipe recipe) {
    _recipeName['initialValue'] =
        recipe.recipeMeal != null ? recipe.recipeMeal : '';
    return buildExpanend(
        Text(text),
        Form(
          key: _form,
          child: CustomTextField(
            isEditMode: true,
            props: _recipeName,
            onChange: (val) {
              setState(() {
                _recipeName['value'] = val;
              });
            },
            onSubmited: (val) {
              if (mode == RecipeMode.Edit && val != '')
                BlocProvider.of<RecipeBloc>(context).add(UpdateRecipeName(val));
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

  Widget _addInputs(Recipe recipe) {
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

  List<Widget> _buildInputs(RecipeLoadSuccess state) {
    var text = "";
    final recipe = state.recipe;
    Widget inputs = _createInputs(text, recipe);
    switch (mode) {
      case RecipeMode.Add:
        text = recipe.recipeMeal;
        inputs = _addInputs(recipe);
        break;
      case RecipeMode.Create:
        text = "Name your Recipe";
        break;
      case RecipeMode.Edit:
        text = "Edit your Recipe";
        break;
    }
    return [Header(text), inputs];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(mode == RecipeMode.Add
              ? 'Add your recipe'
              : mode == RecipeMode.Create
                  ? "Create your recipe"
                  : "Edit Recipe"),
          actions: <Widget>[
            IconButton(
                icon:
                    Icon(mode == RecipeMode.Create ? Icons.save : Icons.delete),
                color: Colors.white,
                iconSize: 35,
                enableFeedback: true,
                onPressed: () {
                  if (mode == RecipeMode.Create)
                    saveForm();
                  else
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                  'Do you really want to remove this recipe?',
                                  style: Theme.of(context).textTheme.subtitle),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
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
                        BlocProvider.of<RecipeBloc>(context)
                            .add(DeleteRecipe(recipeId));
                    });
                }),
            if (mode == RecipeMode.Edit || mode == RecipeMode.Add)
              IconButton(
                  icon:
                      Icon(mode == RecipeMode.Edit ? Icons.clear : Icons.edit),
                  onPressed: () {
                    setState(() {
                      mode = mode == RecipeMode.Edit
                          ? RecipeMode.Add
                          : RecipeMode.Edit;
                    });
                  })
          ],
        ),
        body: BlocConsumer<RecipeBloc, RecipeState>(
          listener: (context, state) {
            if (state is RecipeSavedSuccess) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Saved Successfully'),
                backgroundColor: Theme.of(context).primaryColor,
              ));
              BlocProvider.of<RecipeBloc>(context).add(LoadRecipes());
              Future.delayed(Duration(seconds: 1)).then((_) {
                Navigator.of(context).pop();
              });
            }
            if (state is RecipeDeleteSuccess) Navigator.of(context).pop();
          },
          builder: (context, state) {
            if (state is RecipeLoadSuccess) {
              final meals = state.recipe.meals;
              final recipe = state.recipe;

              return SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  ..._buildInputs(state),
                  Divider(),
                  MacrosSlim(
                    calories: mode == RecipeMode.Edit
                        ? recipe.getTotalCalories
                        : recipe.getTotalCalories * servingSize,
                    carbs: mode == RecipeMode.Edit
                        ? recipe.getCarbs
                        : recipe.getCarbs * servingSize,
                    fats: mode == RecipeMode.Edit
                        ? recipe.getFats
                        : recipe.getFats * servingSize,
                    protein: mode == RecipeMode.Edit
                        ? recipe.getProtein
                        : recipe.getProtein * servingSize,
                  ),
                  Divider(),
                  ...meals
                      .map((e) => mode == RecipeMode.Edit
                          ? GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    MealPreview.routeName,
                                    arguments: {
                                      "meal": e,
                                      "origin": MealOrigin.Recipe
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
            mode == RecipeMode.Create || mode == RecipeMode.Edit
                ? Card(
                    shape: CircleBorder(
                        side: BorderSide(width: 0.5, color: Colors.black54)),
                    elevation: 3,
                    child: IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).pushNamed(Search.routeName,
                              arguments: MealOrigin.Recipe);
                        }),
                  )
                : null,
        bottomNavigationBar: mode == RecipeMode.Add
            ? BlocBuilder<RecipeBloc, RecipeState>(
                builder: (context, state) {
                  if (state is RecipeLoadSuccess) {
                    final recipe = state.recipe;
                    return BottomButton(() {
                      final recipeToAdd = MealItem(
                          servingName: 'Serving(s)',
                          servingSize: servingSize,
                          carbs: servingSize * recipe.getCarbs,
                          protein: servingSize * recipe.getProtein,
                          fats: servingSize * recipe.getFats,
                          mealName: state.recipe.recipeMeal,
                          origin: MealOrigin.Recipe,
                          id: state.recipe.id);

                      BlocProvider.of<TrackBloc>(context).add(
                          TrackAddMeal(recipeToAdd, groupName, oldGroupName));
                      Navigator.of(context).pop();
                    }, 'Add Recipe');
                  }
                  return Text('');
                },
              )
            : null);
  }
}
