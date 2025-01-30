import 'package:frontend/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AuthLocalRepository {
  String tableName = "users";

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
    // ! android: /data/user/0/com.example.frontend/databases/auth.db
    final path = join(dbPath, "auth.db");
    // ! openDatabase itu untuk membuka database
    return openDatabase(path, version: 2,
        onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < newVersion) {
        await db.execute('''
          DROP TABLE $tableName
            ''');
      }
    }, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE $tableName(
          id TEXT PRIMARY KEY,
          email TEXT NOT NULL,
          name TEXT NOT NULL,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
          )
      ''');
    });
  }

  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert(tableName, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.delete(tableName);
  }

  Future<UserModel?> getUser() async {
    final db = await database;
    // ! result nya itu berupa list of map
    final result = await db.query(tableName, limit: 1);
    if (result.isEmpty) {
      return null;
    }
    // ! jadi harus di convert dulu ke UserModel
    return UserModel.fromMap(result.first);
  }
}
