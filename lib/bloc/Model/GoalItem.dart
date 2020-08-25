import './model.dart';

class GoalItem extends Macro {
  String id;
  final String goalName;
  final Macro goal;
  var isActive = null;

  set setId(String newId) {
    id = newId;
  }

  GoalItem({this.id, this.goalName, this.goal, this.isActive})
      : super(goal.protein, goal.carbs, goal.fats);
  Map<String, dynamic> toJson() => {
        'goalName': goalName,
        'protein': goal.protein,
        'carbs': goal.carbs,
        'fats': goal.fats
      };
}
