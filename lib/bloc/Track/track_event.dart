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
  final MealTrack mealItem;
  const TrackEditMeal(this.mealItem);

  @override
  List<Object> get props => [mealItem];
}

class TrackRemoveMeal extends TrackEvent {
  final String id;
  const TrackRemoveMeal(this.id);

  @override
  List<Object> get props => [id];
}
