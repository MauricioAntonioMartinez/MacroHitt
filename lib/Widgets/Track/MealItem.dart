import 'package:flutter/material.dart';

import '../../bloc/Model/model.dart';
import '../../screens/Add_Recipie.dart';
import '../../screens/meal_preview.dart';
import '../Meal/MealItemDismissiable.dart';
import '../MealInformation/MealItemSlimDetails.dart';

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
          Navigator.of(context).pushNamed(AddRecipieWidget.routeName,
              arguments: {"mealId": mealItem.id, "mode": RecipieMode.Add});
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
            ? MealItemSlimDetails(mealItem: mealItem)
            : DismissiableMeal(groupName: groupName, mealItem: mealItem),
      ),
    );
  }
}
