import '../Model/model.dart';
import '../../db/db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../Model/Crud.dart';

class GoalItemRepository implements CRUD<GoalItem> {
  final uuid = Uuid();

  Future<GoalItem> addItem(GoalItem goalItem) async {
    final id = uuid.v4();

    final database = await db();
    await database.insert(
      'goal',
      {'id': id, ...goalItem.toJson()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    goalItem.setId = id;

    return goalItem;
  }

  Future<void> deleteItem(String id) async {
    final database = await db();
    await database.delete(
      'goal',
      where: "id = ?",
      whereArgs: [id],
    );
    await database.delete('track_meal', where: "id=?", whereArgs: [id]);
  }

  Future<GoalItem> updateItem(GoalItem goalItem) async {
    final database = await db();
    await database.update('goal', goalItem.toJson(),
        where: 'id=?', whereArgs: [goalItem.id]);
    return goalItem;
  }

  Future<List<GoalItem>> findItems() async {
    final database = await db();
    final data = await database.query('goal');
    final List<GoalItem> goals = [];

    data.forEach((goal) => goals.add(GoalItem(
        id: goal['id'],
        goalName: goal['goalName'],
        goal: Macro(goal['protein'], goal['carbs'], goal['fats']),
        isActive: goal['isActive'])));

    return goals;
  }

  Future<void> setActiveGoal(String prevActive, String nextActive) async {
    final database = await db();

    await database.update('goal', {'isActive': null},
        where: 'id=?', whereArgs: [prevActive]);
    await database.update('goal', {'isActive': 1},
        where: 'id=?', whereArgs: [nextActive]);
  }

  Future<GoalItem> findItem(String id) async {}
}
