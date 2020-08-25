import '../bloc/Model/model.dart';
import '../db/db.dart';

MealGroupName dbGrpToGroupName(String grp) {
  MealGroupName groupName;
  switch (grp) {
    case 'BreakFast':
      groupName = MealGroupName.BreakFast;
      break;
    case 'Lunch':
      groupName = MealGroupName.Lunch;
      break;
    case 'Dinner':
      groupName = MealGroupName.Dinner;
      break;
    case 'Snack':
      groupName = MealGroupName.Snack;
      break;
    default:
      groupName = MealGroupName.BreakFast;
  }
  return groupName;
}

Future<String> grpToId(MealGroupName grp) async {
  final database = await db();
  final newGroupId = await database.rawQuery(
      'SELECT id FROM meal_group WHERE groupName=?;',
      [grp.toString().split('.').last]);

  return newGroupId.length > 0 ? newGroupId[0]['id'] : null;
}
