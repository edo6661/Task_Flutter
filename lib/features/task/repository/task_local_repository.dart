import 'package:frontend/models/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskLocalRepository {
  String tableName = "tasks";

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    // ! Get the default databases location.
    final dbPath = await getDatabasesPath();
    // ! android: /data/task/0/com.example.frontend/databases/auth.db
    final path = join(dbPath, "tasks.db");
    // ! openDatabase itu untuk membuka database
    return openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE $tableName(
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          hexColor TEXT NOT NULL,
          dueAt TEXT NOT NULL,
          userId TEXT NOT NULL,
          isSynced INTEGER NOT NULL,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
          )
      ''');
    });
  }

  Future<void> insertTasks(List<TaskModel> tasks) async {
    final db = await database;
    final batch = db.batch();
    for (final task in tasks) {
      batch.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    // ! nge prevent duplicate data
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [task.id],
    );
    // ! harus nge convert dulu ke map karena insert itu nerima map
    await db.insert(tableName, task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteTask() async {
    final db = await database;
    await db.delete(tableName);
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final result = await db.query(tableName);
    if (result.isEmpty) {
      return [];
    }
    // ! result nge return list of map, jadi harus di convert
    return result.map((task) => TaskModel.fromMap(task)).toList();
  }

  Future<List<TaskModel>> getUnsyncedTasks() async {
    final db = await database;
    // ! nyari task yang isSynced nya 0
    final result =
        await db.query(tableName, where: 'isSynced = ?', whereArgs: [0]);
    if (result.isNotEmpty) {
      return result.map((task) => TaskModel.fromMap(task)).toList();
    }
    return [];
  }

  Future<void> updateSync({required String id, required int isSynced}) async {
    final db = await database;
    // ! nyari task yang isSynced nya 0
    await db.update(
      tableName,
      {
        'isSynced': isSynced,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
