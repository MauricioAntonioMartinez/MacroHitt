import 'package:HIIT/Widgets/UI/BottomButton.dart';
import 'package:HIIT/bloc/Model/model.dart';
import 'package:HIIT/bloc/Track/track_bloc.dart';
import 'package:HIIT/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddRecipeButton extends StatelessWidget {
  const AddRecipeButton({
    Key key,
    @required this.servingSize,
    @required this.groupName,
    @required this.oldGroupName,
  }) : super(key: key);

  final double servingSize;
  final MealGroupName groupName;
  final MealGroupName oldGroupName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
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
      );
  }
}
