import 'package:HIIT/bloc/Model/MealItem.dart';
import 'package:HIIT/bloc/Model/model.dart';

class MealTrackItem {
  final String id;
  final String mealId;
  final String trackId;
  final String groupId;
  final double qty;
  final MealOrigin origin;

  MealTrackItem(
      this.id, this.mealId, this.trackId, this.groupId, this.qty, this.origin);

  Map<String, dynamic> toJson() => {
        'id': id,
        'meal_id': mealId,
        'track_id': trackId,
        'group_id': groupId,
        'origin': origin.toString().split('.')[1], //
        'qty': qty
      };
}
