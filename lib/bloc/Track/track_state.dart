part of 'track_bloc.dart';

@immutable
abstract class TrackState extends Equatable {
  const TrackState();
  @override
  List<Object> get props => [];
}

class TrackMealTrackGroupLoadedSuccess extends TrackState {
  final List<MealItem> mealBloc;
  const TrackMealTrackGroupLoadedSuccess({this.mealBloc});
  @override
  List<Object> get props => [mealBloc];
}

class TrackLoadDaySuccess extends TrackState {
  final Track trackDay;
  TrackLoadDaySuccess(this.trackDay);
}

class TrackLoading extends TrackState {}

class TrackLoadedFailure extends TrackState {
  final String message;
  TrackLoadedFailure(this.message);
}
