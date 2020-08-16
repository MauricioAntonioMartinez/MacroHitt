part of 'track_bloc.dart';

@immutable
abstract class TrackEvent extends Equatable {
  const TrackEvent();
  @override
  List<Object> get props => [];
}

class TrackLoadDay extends TrackEvent {
  final DateTime date;
  TrackLoadDay(this.date);
}

class TrackAddMeal extends TrackEvent {
  final MealTrack mealItem;
  const TrackAddMeal(this.mealItem);
  @override
  List<Object> get props => [mealItem];
}

class TrackEditMeal extends TrackEvent {
  final MealItem meal;
  final MealGroupName newGroupName;
  final MealGroupName oldGroupName;
  const TrackEditMeal(this.meal, this.newGroupName, this.oldGroupName);
  @override
  List<Object> get props => [meal, newGroupName, oldGroupName];
}

class TrackRemoveMeal extends TrackEvent {
  final String id;
  final MealGroupName mealGroupName;

  const TrackRemoveMeal(this.id, this.mealGroupName);

  @override
  List<Object> get props => [id, mealGroupName];
}
