import 'package:frontend/core/enums.dart';
import 'package:frontend/core/utils/log_service.dart';
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
    return openDatabase(path, version: 2, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE $tableName(
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          hexColor TEXT NOT NULL,
          dueAt TEXT NOT NULL,
          userId TEXT NOT NULL,
          isSynced INTEGER NOT NULL,
          isDeleted INTEGER NOT NULL,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
          )
      ''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < newVersion) {
        await db.execute('''
            ALTER TABLE $tableName ADD COLUMN isDeleted INTEGER NOT NULL DEFAULT 0
            ''');
      }
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

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'isDeleted = ?',
      whereArgs: [
        DeleteStatus.notDeleted.index,
      ],
    );
    if (result.isEmpty) {
      return [];
    }
    // ! result nge return list of map, jadi harus di convert
    return result.map((task) => TaskModel.fromMap(task)).toList();
  }

  Future<List<TaskModel>> getUnsyncedTasks() async {
    final db = await database;
    // ! nyari task yang isSynced nya 0
    final result = await db.query(tableName, where: 'isSynced = ?', whereArgs: [
      SyncStatus.unsynced.index,
    ]);
    if (result.isNotEmpty) {
      return result.map((task) => TaskModel.fromMap(task)).toList();
    }
    return [];
  }

  Future<void> updateSync({required String id, required int isSynced}) async {
    final db = await database;
    await db.update(
      tableName,
      {
        'isSynced': isSynced,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.update(
      tableName,
      {
        'isDeleted': DeleteStatus.deleted.index,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTasks() async {
    final db = await database;
    await db.delete(tableName);
  }

  Future<List<TaskModel>> getDeletedTasks() async {
    final db = await database;
    final result =
        await db.query(tableName, where: 'isDeleted = ?', whereArgs: [
      DeleteStatus.deleted.index,
    ]);
    if (result.isEmpty) {
      return [];
    }
    return result.map((task) => TaskModel.fromMap(task)).toList();
  }

  Future<void> removeAllDeletedTask() async {
    final db = await database;
    await db.delete(tableName,
        where: 'isDeleted = ?', whereArgs: [DeleteStatus.deleted.index]);
  }
}
