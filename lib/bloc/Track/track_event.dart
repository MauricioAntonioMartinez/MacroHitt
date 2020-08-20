part of 'track_bloc.dart';

@immutable
abstract class TrackEvent extends Equatable {
  const TrackEvent();
  @override
  List<Object> get props => [];
}

class TrackLoadDay extends TrackEvent {
  final DateTime date;
  final List<Track> tracks;
  TrackLoadDay(this.date, [this.tracks]);
}

class TrackAddMeal extends TrackEvent {
  final MealItem meal;
  final MealGroupName newGroupName;
  final MealGroupName oldGroupName;
  const TrackAddMeal(this.meal, this.newGroupName, this.oldGroupName);
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
