class MealTrackItem {
  final String id;
  final String mealId;
  final String trackId;
  final String groupId;
  final double qty;

  MealTrackItem(this.id, this.mealId, this.trackId, this.groupId, this.qty);

  Map<String, dynamic> toJson() => {
        'id': id,
        'meal_id': mealId,
        'track_id': trackId,
        'group_id': groupId,
        'qty': qty
      };
}
