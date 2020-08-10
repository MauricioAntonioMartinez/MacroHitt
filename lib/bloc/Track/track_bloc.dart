import 'dart:async';
import 'package:intl/intl.dart';
import '../Model/model.dart';
import '../meal/meal_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/day_track.dart';
part 'track_event.dart';
part 'track_state.dart';

class TrackBloc extends Bloc<TrackEvent, TrackState> {
  final MealBloc mealBloc;
  StreamSubscription mealTrackGroupSubscription;
  TrackBloc({this.mealBloc}) : super(TrackLoading()) {
    mealTrackGroupSubscription = mealBloc.listen((state) {
      if (state is MealLoadSuccess) {
        add(TrackLoadDay(DateTime.now()));
      }
    });
  }
  @override
  Stream<TrackState> mapEventToState(
    TrackEvent event,
  ) async* {
    if (event is TrackAddMeal) {
      yield* _mapTrackMealAddedToStat(event);
    } else if (event is TrackLoadDay) {
      yield* _mapTrackDayToState(event);
    }
  }

  Stream<TrackState> _mapTrackMealAddedToStat(TrackAddMeal event) async* {
    try {
      // if (state is TrackInitalState) yield TrackLoading();
    } catch (_) {}
  }

  Stream<TrackState> _mapTrackDayToState(TrackLoadDay event) async* {
    var formatedDate = DateFormat('yyyy-MM-dd').format(event.date);

    var macroDay = trakDays.firstWhere(
        (day) => DateFormat('yyyy-MM-dd').format(day.date) == formatedDate,
        orElse: () =>
            Track(date: event.date, goals: Macro(0, 0, 0), mealGroup: {}));
    // print(mealBloc.state);

    try {
      final formatedMeals = macroDay
          .trackMealsToItemMeals((mealBloc.state as MealLoadSuccess).myMeals);

      yield TrackLoadDaySuccess(
          date: formatedDate,
          macroTarget: macroDay.goals,
          meals: formatedMeals);
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> close() {
    mealTrackGroupSubscription.cancel();
    return super.close();
  }
}
