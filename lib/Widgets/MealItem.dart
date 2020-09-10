import 'package:flutter/material.dart';

import '../Widgets/Meal/dismissiable_meal.dart';
import '../Widgets/Meal/meal_info.dart';
import '../bloc/Model/model.dart';
import '../screens/Add_Recipie.dart';
import '../screens/meal_preview.dart';

class MealItemWidget extends StatelessWidget {
  final MealItem mealItem;
  final MealGroupName groupName;
  final MealOrigin origin;
  final bool isDismissible;
  MealItemWidget(this.mealItem, this.isDismissible, this.origin,
      [this.groupName]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var arguments = {
          "meal": mealItem,
          "groupName": groupName,
          "origin": origin
        };
        if (mealItem.origin == MealOrigin.Recipie)
          Navigator.of(context)
              .pushNamed(AddRecipieWidget.routeName, arguments: mealItem.id);
        else
          Navigator.of(context)
              .pushNamed(MealPreview.routeName, arguments: arguments);
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.symmetric(
                horizontal: BorderSide(color: Colors.white),
                vertical: BorderSide(color: Colors.grey, width: 0.1))),
        child: !isDismissible
            ? MealInfo(mealItem: mealItem)
            : DismissiableMeal(groupName: groupName, mealItem: mealItem),
      ),
    );
  }
}
