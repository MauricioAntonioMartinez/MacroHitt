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
    } else if (event is TrackEditMeal) {
      yield* _editMealTrack(event);
    }
  }

  Stream<TrackState> _editMealTrack(TrackEditMeal event) async* {
    yield TrackLoading();
    try {
      // Old Track Day Data
      final currentTrackDay = (state as TrackLoadDaySuccess);
      var mealsTrack = currentTrackDay.meals;

      //New Meal data
      final newGroup = event.newGroupName;
      final oldGroup = event.oldGroupName;
      final newMeal = event.meal;

      //Replacement
      if (oldGroup == null) {
        if (mealsTrack.keys.toList().contains(newGroup))
          mealsTrack[newGroup].add(newMeal);
        else
          mealsTrack[newGroup] = [newMeal];
      } else if (newGroup == oldGroup) {
        mealsTrack[newGroup].map((e) {
          if (e.id == newMeal.id) e = newMeal;
          return e;
        }).toList();
      } else {
        mealsTrack[oldGroup].removeWhere((m) => m.id == newMeal.id);

        if (mealsTrack[oldGroup].isEmpty)
          mealsTrack.removeWhere((key, value) => key == oldGroup);

        if (mealsTrack.keys.toList().contains(newGroup)) {
          final isThisMealinNewGroup = mealsTrack[newGroup]
              .firstWhere((m) => m.id == newMeal.id, orElse: () => null);
          if (isThisMealinNewGroup == null)
            mealsTrack[newGroup].add(newMeal);
          else
            mealsTrack[newGroup].map((e) {
              if (e.id == newMeal.id) e = newMeal;
              return e;
            }).toList();
        } else {
          mealsTrack[newGroup] = [newMeal];
        }
      }

      //Yielding results
      yield TrackLoadDaySuccess(
          date: currentTrackDay.date,
          macroTarget: currentTrackDay.macroTarget,
          meals: mealsTrack);
    } catch (e) {
      TrackLoadedFailure(e.message);
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
