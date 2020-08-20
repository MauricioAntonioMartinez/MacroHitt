import 'dart:async';
import 'package:intl/intl.dart';
import '../Model/model.dart';
import '../meal/meal_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/day_track.dart';
import '../../db/db.dart';
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
    if (event is TrackLoadDay) {
      yield* _mapTrackDayToState(event);
    } else if (event is TrackAddMeal) {
      yield* _addMealTrack(event);
    } else if (event is TrackRemoveMeal) {
      yield* _removeMealTrack(event);
    }
  }

  Stream<TrackState> _removeMealTrack(TrackRemoveMeal event) async* {
    final day = (state as TrackLoadDaySuccess); // day cached
    yield TrackLoading();
    try {
      var dayToTrackIndex = trackDays.indexWhere(
        (d) =>
            DateFormat.yMMMd().format(d.date) ==
            DateFormat.yMMMd().format(day.trackDay.date),
      );
      Track trackingDay = trackDays[dayToTrackIndex];
      final currentDate = trackingDay.date;
      final mealGroupName = event.mealGroupName;
      final mealItem = trackDays[dayToTrackIndex]
          .meals[mealGroupName]
          .firstWhere((m) => m.id == event.id);

      trackingDay.meals[mealGroupName]
          .removeWhere((meal) => meal.id == event.id);

      if (trackingDay.meals[mealGroupName].isEmpty)
        trackingDay.meals.removeWhere((key, value) => key == mealGroupName);

      if (trackDays[dayToTrackIndex].meals.isEmpty) trackingDay = null;

      Track newTracking;
      if (trackingDay != null) {
        final newMacros = Macro(
            trackingDay.macrosConsumed.protein - mealItem.protein,
            trackingDay.macrosConsumed.carbs - mealItem.carbs,
            trackingDay.macrosConsumed.fats - mealItem.fats);
        newTracking = Track({},
            date: trackingDay.date,
            macrosConsumed: newMacros,
            meals: trackingDay.meals);
        trackDays[dayToTrackIndex] = newTracking;
      } else {
        newTracking = Track({},
            date: currentDate, macrosConsumed: Macro(0, 0, 0), meals: {});
        trackDays.removeAt(dayToTrackIndex);
      }
      yield TrackLoadDaySuccess(newTracking);

      //Yielding results

    } catch (e) {
      yield TrackLoadedFailure('CANNOT DELETE MEAL');
    }
  }

  Stream<TrackState> _addMealTrack(TrackAddMeal event) async* {
    final day = (state as TrackLoadDaySuccess);
    yield TrackLoading();

    try {
      print(trackDays);
      // Old Track Day Data ,Create Day if added meal and pushed

      var dayTrackIndex = trackDays.indexWhere(
        (d) =>
            DateFormat.yMMMd().format(d.date) ==
            DateFormat.yMMMd().format(day.trackDay.date),
      );
      Track dayToTrack;
      if (dayTrackIndex == -1)
        dayToTrack = day.trackDay;
      else
        dayToTrack = trackDays[dayTrackIndex];

      //Old Meal Macros if already in the track
      var isInTheTrack = false;
      var oldMealCarbs;
      var oldMealFats;
      var oldMealProtein;

      //Old Data (DAY)
      final mealsTrack = dayToTrack.meals;
      var oldCarbs = dayToTrack.macrosConsumed.carbs;
      var oldFats = dayToTrack.macrosConsumed.fats;
      var oldProtein = dayToTrack.macrosConsumed.protein;

      //New Meal data
      final newMeal = event.meal;
      final mealProtein = newMeal.protein;
      final mealCarbs = newMeal.carbs;
      final mealFats = newMeal.fats;
      final newGroup = event.newGroupName;
      final oldGroup = event.oldGroupName;

      //Replacement
      if (oldGroup == null) {
        if (mealsTrack.keys.toList().contains(newGroup)) {
          final indexMeal =
              mealsTrack[newGroup].indexWhere((m) => m.id == newMeal.id);
          if (indexMeal != -1) {
            // The meal is already in the track
            isInTheTrack = true;
            final mealFound = mealsTrack[newGroup][indexMeal];
            oldMealCarbs = mealFound.carbs;
            oldMealFats = mealFound.fats;
            oldMealProtein = mealFound.protein;
            mealsTrack[newGroup][indexMeal] = newMeal;
          } else {
            mealsTrack[newGroup].add(newMeal);
          }
        } else
          mealsTrack[newGroup] = [newMeal];
      } else if (newGroup == oldGroup) {
        final indexMeal =
            mealsTrack[newGroup].indexWhere((m) => m.id == newMeal.id);
        if (indexMeal != -1) {
          isInTheTrack = true;
          // The meal is already in the track
          final mealFound = mealsTrack[newGroup][indexMeal];
          oldMealCarbs = mealFound.carbs;
          oldMealFats = mealFound.fats;
          oldMealProtein = mealFound.protein;

          mealsTrack[newGroup][indexMeal] = newMeal;
        }
      } else {
        mealsTrack[oldGroup].removeWhere((m) => m.id == newMeal.id);

        if (mealsTrack[oldGroup].isEmpty)
          mealsTrack.removeWhere((key, value) => key == oldGroup);

        if (mealsTrack.keys.toList().contains(newGroup)) {
          final isThisMealinNewGroup = mealsTrack[newGroup]
              .firstWhere((m) => m.id == newMeal.id, orElse: () => null);
          if (isThisMealinNewGroup == null)
            mealsTrack[newGroup].add(newMeal);
          else {
            isInTheTrack = true;
            //already in Track
            mealsTrack[newGroup].map((e) {
              if (e.id == newMeal.id) {
                final mealFound = e;
                oldMealCarbs = mealFound.carbs;
                oldMealFats = mealFound.fats;
                oldMealProtein = mealFound.protein;
                return newMeal;
              }
              return e;
            }).toList();
          }
        } else {
          mealsTrack[newGroup] = [newMeal];
        }
      }
      var newMacros;

      if (isInTheTrack) {
        newMacros = Macro(
            oldProtein - oldMealProtein + mealProtein,
            oldCarbs - oldMealCarbs + mealCarbs,
            oldFats - oldMealFats + mealFats);
      } else {
        newMacros = Macro(
            oldProtein + mealProtein, oldCarbs + mealCarbs, oldFats + mealFats);
      }

      //Yielding results
      final trackDay = Track({},
          date: dayToTrack.date, macrosConsumed: newMacros, meals: mealsTrack);

      if (dayTrackIndex == -1)
        trackDays.add(trackDay);
      else
        trackDays[dayTrackIndex] = trackDay;

      yield TrackLoadDaySuccess(trackDay);
    } catch (e) {
      print(e);
      TrackLoadedFailure('WENT GRONG');
    }
  }

  Stream<TrackState> _mapTrackDayToState(TrackLoadDay event) async* {
    yield TrackLoading();
    try {
      final database = await db();
      final List<Map<String, dynamic>> tracks = await database.query('track');

      final List<Track> trackDays = [];
      // SAVING ALL THE MEALS IN THE CACHE AND FETCHING THE CURRENT TRACK DAY
      for (final tr in tracks) {
        final List<Map<String, dynamic>> mealsTrack = await database.rawQuery(
            'SELECT * FROM track_meal A INNER JOIN meal_grop B ON A.group_id=B.id  WHERE track_id=?',
            [tr['id']]);
        final Map<MealGroupName, List<MealTrack>> trackMeals = {};

        mealsTrack.forEach((meal) {
          trackMeals[meal['groupName']]
              .add(MealTrack(id: meal['id'], qty: double.parse(meal['qty'])));
          ;
        });

        trackDays.add(Track(trackMeals,
            date: DateTime(tr['date']),
            macrosConsumed: Macro(tr['protein'], tr['carbs'], tr['fats']),
            meals: {}));
      }

      final formatedDate = DateFormat.yMMMd().format(event.date);
      final macroDay = trackDays.firstWhere(
          (day) => DateFormat.yMMMd().format(day.date) == formatedDate,
          orElse: () => Track({},
              date: event.date, macrosConsumed: Macro(0, 0, 0), meals: {}));
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
