import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../util/track.dart';
import '../Model/model.dart';
import '../Repositories/index.dart';
import '../bloc.dart';
import '../meal/meal_bloc.dart';

part 'track_event.dart';
part 'track_state.dart';

var uuidd = Uuid();

class TrackBloc extends Bloc<TrackEvent, TrackState> {
  final MealBloc mealBloc;
  StreamSubscription mealTrackGroupSubscription;
  StreamSubscription recipieTrackGroupSubscription;
  final RecipieBloc recipieBloc;
  final TrackRepository trackRepository;
  final TrackItemRepository trackItemRepository;
  TrackBloc(
      {@required this.mealBloc,
      @required this.trackRepository,
      @required this.trackItemRepository,
      @required this.recipieBloc})
      : super(TrackLoading()) {
    mealTrackGroupSubscription = mealBloc.listen((state) {
      if (state is MealLoadSuccess) {
        add(TrackLoadDay(DateTime.now()));
      }
    });
    recipieTrackGroupSubscription = recipieBloc.listen((state) {
      if (state is Recipies) {
        //add(TrackLoadDay(DateTime.now()));
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
      final trackingDay = day.trackDay;
      final groupId = await grpToId(event.mealGroupName);
      final trackMealItem = MealTrackItem(
          '', event.id, trackingDay.id, groupId, 1, MealOrigin.Track);
      await trackItemRepository.deleteItem(event.id, trackMealItem);
      final mealItem = trackingDay.meals[event.mealGroupName]
          .firstWhere((meal) => meal.id == event.id);

      final mealGroupName = event.mealGroupName;
      trackingDay.meals[mealGroupName]
          .removeWhere((meal) => meal.id == event.id);

      if (trackingDay.meals[mealGroupName].isEmpty)
        trackingDay.meals.removeWhere((key, value) => key == mealGroupName);
      Track newTracking;
      if (trackingDay.meals.isNotEmpty) {
        final newMacros = Macro(
            trackingDay.macrosConsumed.protein - mealItem.protein,
            trackingDay.macrosConsumed.carbs - mealItem.carbs,
            trackingDay.macrosConsumed.fats - mealItem.fats);
        newTracking = Track(
            date: trackingDay.date,
            macrosConsumed: newMacros,
            meals: trackingDay.meals);
      } else {
        await trackRepository.deleteItem(trackingDay.id);
        newTracking = Track(
            id: '',
            date: trackingDay.date,
            macrosConsumed: Macro(0, 0, 0),
            meals: {});
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
      final newMeal = event.meal;
      if (newMeal.origin == MealOrigin.Recipie) {
        newMeal.setOrigin = MealOrigin.Recipie;
      } else
        newMeal.setOrigin = MealOrigin.Track;
      final currentTrack = day.trackDay;
      final isNewTrack = currentTrack.id == '';
      Track dayToTrack;
      final idTrack = uuidd.v4();
      if (isNewTrack)
        dayToTrack = await trackRepository.addItem(currentTrack, idTrack);
      else
        dayToTrack = currentTrack;
      final idTrackMeal = uuidd.v4();
      final newGroupId = await grpToId(event.newGroupName);
      final oldGroupId = await grpToId(event.oldGroupName);
      final trackMealItem = MealTrackItem(
          idTrackMeal,
          newMeal.id,
          isNewTrack ? idTrack : currentTrack.id,
          newGroupId,
          newMeal.servingSize,
          newMeal.origin);

      //OLD MEAL DATA
      var oldMealCarbs = 0.0;
      var oldMealFats = 0.0;
      var oldMealProtein = 0.0;

      //Old Data (DAY)
      final mealsTrack = dayToTrack.meals;
      var oldCarbs = dayToTrack.macrosConsumed.carbs;
      var oldFats = dayToTrack.macrosConsumed.fats;
      var oldProtein = dayToTrack.macrosConsumed.protein;

      //New Meal data
      final mealProtein = newMeal.protein;
      final mealCarbs = newMeal.carbs;
      final mealFats = newMeal.fats;
      final newGroup = event.newGroupName;
      final oldGroup = event.oldGroupName;

      // Meal Item
      MealItem mealFoundInTrack;
      //TODO: Refactor the code to be more optimized, get rid of code duplication
      //Replacement
      if (oldGroup == null) {
        if (mealsTrack.keys.toList().contains(newGroup)) {
          final indexMeal =
              mealsTrack[newGroup].indexWhere((m) => m.id == newMeal.id);
          if (indexMeal != -1)
            mealFoundInTrack = mealsTrack[newGroup][indexMeal];
          else
            mealsTrack[newGroup].add(newMeal);
        } else
          mealsTrack[newGroup] = [newMeal];
      } else if (newGroup == oldGroup) {
        final indexMeal = mealsTrack[newGroup].indexWhere((m) {
          return m.id == newMeal.id;
        });
        if (indexMeal != -1) mealFoundInTrack = mealsTrack[newGroup][indexMeal];
      } else {
        mealsTrack[oldGroup].removeWhere((m) {
          oldMealCarbs = m.carbs;
          oldMealFats = m.fats;
          oldMealProtein = m.protein;
          return m.id == newMeal.id;
        });

        if (mealsTrack[oldGroup].isEmpty)
          mealsTrack.removeWhere((key, value) => key == oldGroup);

        if (mealsTrack.keys.toList().contains(newGroup)) {
          final isThisMealinNewGroup = mealsTrack[newGroup]
              .firstWhere((m) => m.id == newMeal.id, orElse: () => null);
          if (isThisMealinNewGroup == null)
            mealsTrack[newGroup].add(newMeal);
          else {
            //already in Track
            mealsTrack[newGroup].map((e) {
              if (e.id == newMeal.id) {
                mealFoundInTrack = e;
                return newMeal;
              }
              return e;
            }).toList();
          }
        } else {
          //mealFoundInTrack = newMeal;
          mealsTrack[newGroup] = [newMeal];
        }
      }
      Macro newMacros;
      if (mealFoundInTrack != null) {
        final oldMealCarbsFound = mealFoundInTrack.carbs;
        final oldMealFatsFound = mealFoundInTrack.fats;
        final oldMealProteinFound = mealFoundInTrack.protein;
        newMacros = Macro(
            oldProtein - oldMealProteinFound - oldMealProtein + mealProtein,
            oldCarbs - oldMealCarbsFound - oldMealCarbs + mealCarbs,
            oldFats - oldMealFatsFound - oldMealFats + mealFats);

        await trackItemRepository.updateItem(trackMealItem, oldGroupId);
        final indexNewMeal =
            mealsTrack[newGroup].indexWhere((meal) => meal.id == newMeal.id);
        mealsTrack[newGroup][indexNewMeal] = newMeal;
      } else {
        await trackItemRepository.addItem(trackMealItem);
        if (oldMealCarbs != null) {
          newMacros = Macro(
              oldProtein - oldMealProtein + mealProtein,
              oldCarbs - oldMealCarbs + mealCarbs,
              oldFats - oldMealFats + mealFats);
        } else
          newMacros = Macro(oldProtein + mealProtein, oldCarbs + mealCarbs,
              oldFats + mealFats);
      }
      await trackRepository.updateItem(dayToTrack, newMacros);

      //  Yielding results
      final trackDay = Track(
          id: dayToTrack.id,
          date: dayToTrack.date,
          macrosConsumed: newMacros,
          meals: mealsTrack);
      yield TrackLoadDaySuccess(trackDay);
    } catch (e) {
      print(e);
      TrackLoadedFailure('WENT GRONG');
    }
  }

  Stream<TrackState> _mapTrackDayToState(TrackLoadDay event) async* {
    yield TrackLoading();
    if (mealBloc.state is MealLoadSuccess && recipieBloc.state is Recipies) {
      try {
        final userMeals = (mealBloc.state as MealLoadSuccess).myMeals;
        final recipies = (recipieBloc.state as Recipies).recipies;
        final allMeals = [...userMeals, ...recipies];
        final track =
            await trackRepository.findItem(event.date.toString(), allMeals);
        yield TrackLoadDaySuccess(track);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Future<void> close() {
    mealTrackGroupSubscription.cancel();
    recipieTrackGroupSubscription.cancel();
    return super.close();
  }
}
