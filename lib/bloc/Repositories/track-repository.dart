import 'dart:async';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../db/db.dart';
import '../../util/track.dart';
import '../Model/Crud.dart';
import '../Model/model.dart';

class TrackRepository implements CRUD<Track> {
  final uuid = Uuid();

  Future<Track> addItem(Track track, [String id]) async {
    final database = await db();

    await database.insert(
      'track',
      {
        'id': id,
        'date': track.date.toString(),
        'protein': 0,
        'carbs': 0,
        'fats': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return Track(
        id: id, date: track.date, macrosConsumed: Macro(0, 0, 0), meals: {});
  }

  Future<void> deleteItem(String trackId) async {
    final database = await db();
    await database.delete('track', where: 'id=?', whereArgs: [trackId]);
  }

  Future<Track> updateItem(Track track, [Macro macro]) async {
    final database = await db();
    await database.update('track',
        {'protein': macro.protein, 'fats': macro.fats, 'carbs': macro.carbs},
        where: 'id=?', whereArgs: [track.id]);
    return track;
  }

  Future<List<Track>> findItems() async {}

  Future<Track> findItem(String stringDate, [List<MealItem> userMeals]) async {
    final date = DateTime.parse(stringDate);
    final database = await db();
    final List<Map<String, dynamic>> tracks = await database.query('track');
    final currentDay = DateFormat.yMMMd().format(date);

    final trackingDay = tracks.firstWhere(
        (tr) =>
            DateFormat.yMMMd().format(DateTime.parse(tr['date'])) == currentDay,
        orElse: () => null);

    if (trackingDay != null) {
      final List<Map<String, dynamic>> mealsTrack = await database.rawQuery(
          'SELECT * FROM track_meal A INNER JOIN meal_group B ON A.group_id=B.id  WHERE track_id=?',
          [trackingDay['id']]);
      final Map<MealGroupName, List<MealTrack>> trackMeals = {};
      mealsTrack.forEach((meal) {
        MealGroupName groupName = dbGrpToGroupName(meal['groupName']);
        trackMeals[groupName] = [
          ...(trackMeals[groupName] != null ? [...trackMeals[groupName]] : []),
          MealTrack(
              id: meal['meal_id'], qty: meal['qty'], origin: meal['origin'])
        ];
      });
      final meals = Track.trackMealsToItemMeals(userMeals, trackMeals);
      return Track(
          id: trackingDay['id'],
          date: date,
          macrosConsumed: Macro(trackingDay['protein'], trackingDay['carbs'],
              trackingDay['fats']),
          meals: meals);
    } else {
      return Track(
          id: '', date: date, macrosConsumed: Macro(0, 0, 0), meals: {});
    }
  }

  Future<void> updateMacrosTracks(MealItem prevMeal, [MealItem newMeal]) async {
    final database = await db();

    final tracks = await database.rawQuery('''
      SELECT protein,carbs,fats,T.id as trackId,qty FROM track T INNER JOIN track_meal M ON T.id = M.track_id WHERE
        M.meal_id = ?; 
    ''', [prevMeal.id]);

    for (final track in tracks) {
      final qty = track['qty'];
      await database.update(
          'track',
          {
            "protein": track['protein'] -
                prevMeal.protein * qty +
                (newMeal == null ? 0.0 : newMeal.protein) * qty,
            "carbs": track['carbs'] -
                prevMeal.carbs * qty +
                (newMeal == null ? 0.0 : newMeal.carbs) * qty,
            "fats": track['fats'] -
                prevMeal.fats * qty +
                (newMeal == null ? 0.0 : newMeal.fats) * qty,
          },
          where: 'id=?',
          whereArgs: [track['trackId']]);
    }
  }
}
