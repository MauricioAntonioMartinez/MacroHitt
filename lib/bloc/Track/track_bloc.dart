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
        print(state);
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
      yield* _addMealTrack(event);
    } else if (event is TrackRemoveMeal) {
      yield* _removeMealTrack(event);
    }
  }

  Stream<TrackState> _removeMealTrack(TrackRemoveMeal event) async* {
    final day = (state as TrackLoadDaySuccess); // day cached
    yield TrackLoading();
    try {
      final mealGroupName = event.mealGroupName;
      final newMeals = day.trackDay.meals;
      newMeals[mealGroupName].removeWhere((meal) => meal.id == event.id);
      if (newMeals[mealGroupName].isEmpty && newMeals != null)
        newMeals.removeWhere((key, value) => key == mealGroupName);

      final trackDay = Track(
          date: day.trackDay.date,
          macrosConsumed: day.trackDay.macrosConsumed,
          meals: newMeals);
      yield TrackLoadDaySuccess(trackDay);
    } catch (e) {
      yield TrackLoadedFailure('CANNOT DELETE MEAL');
    }
  }

  Stream<TrackState> _addMealTrack(TrackEditMeal event) async* {
    final day = (state as TrackLoadDaySuccess);
    yield TrackLoading();

    try {
      // Old Track Day Data
      var dayToTrack = trackDays.firstWhere(
          (d) =>
              DateFormat.yMMMd().format(d.date) ==
              DateFormat.yMMMd().format(day.trackDay.date),
          orElse: () => null);
      if (dayToTrack == null) {
        trackDays.add(day.trackDay);
        dayToTrack = day.trackDay;
      }

      print(trackDays);

      final mealsTrack = dayToTrack.meals;

      //New Meal data
      final newGroup = event.newGroupName;
      final oldGroup = event.oldGroupName;
      final newMeal = event.meal;

      //Replacement
      if (oldGroup == null) {
        if (mealsTrack.keys.toList().contains(newGroup)) {
          final indexMeal =
              mealsTrack[newGroup].indexWhere((m) => m.id == newMeal.id);
          indexMeal != null
              ? mealsTrack[newGroup][indexMeal] = newMeal
              : mealsTrack[newGroup].add(newMeal);
        } else
          mealsTrack[newGroup] = [newMeal];
      } else if (newGroup == oldGroup) {
        final indexMeal =
            mealsTrack[newGroup].indexWhere((m) => m.id == newMeal.id);
        if (indexMeal != null) mealsTrack[newGroup][indexMeal] = newMeal;
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
      final trackDay = Track(
          date: dayToTrack.date,
          macrosConsumed: dayToTrack.macrosConsumed,
          meals: mealsTrack);

      yield TrackLoadDaySuccess(trackDay);
    } catch (e) {
      print(e);
      TrackLoadedFailure('WENT GRONG');
    }
  }

  Stream<TrackState> _mapTrackMealAddedToStat(TrackAddMeal event) async* {
    try {
      // if (state is TrackInitalState) yield TrackLoading();
    } catch (_) {}
  }

  Stream<TrackState> _mapTrackDayToState(TrackLoadDay event) async* {
    yield TrackLoading();
    final formatedDate = DateFormat.yMMMd().format(event.date);
    final macroDay = trackDays.firstWhere(
        (day) => DateFormat.yMMMd().format(day.date) == formatedDate,
        orElse: () =>
            Track(date: event.date, macrosConsumed: Macro(0, 0, 0), meals: {}));
    try {
      // final userMeals = [...(mealBloc.state as MealLoadSuccess).myMeals];
      //macroDay.trackMealsToItemMeals(userMeals);

      yield TrackLoadDaySuccess(macroDay);
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
