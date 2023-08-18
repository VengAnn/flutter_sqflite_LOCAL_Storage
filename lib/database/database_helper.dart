import 'package:sqflite/sqflite.dart';
<<<<<<< HEAD

// ignore: unused_import
import 'package:path_provider/path_provider.dart';

=======
// ignore: unused_import
import 'package:path_provider/path_provider.dart';
>>>>>>> 2952aadb7bdf3b50ba52cec25b55bbc3720b036d
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class DatabaseHelper {
  String dbName = 'task.db';
  String tableName = 'task';
  String columnId = 'id';
  String columnTitle = 'title';
  String columnIsDone = 'isDone';
  String columnDate = 'date';
  Database? _database;

  //Create Singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;
<<<<<<< HEAD

=======
>>>>>>> 2952aadb7bdf3b50ba52cec25b55bbc3720b036d
  DatabaseHelper._internal();

  //end of Singleton

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = path.join(databasesPath, dbName);

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableName(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnTitle TEXT NOT NULL,
      $columnIsDone INTEGER NOT NULL,
      $columnDate TEXT NOT NULL)
    ''');
  }

<<<<<<< HEAD
  //insert data
=======
>>>>>>> 2952aadb7bdf3b50ba52cec25b55bbc3720b036d
  static Future<int> insertTask(Map<String, dynamic> row) async {
    final Database db = await DatabaseHelper().database;
    return await db.insert(DatabaseHelper().tableName, row);
  }

  //get task
  static Future<List<Map<String, dynamic>>> getTask() async {
    final Database db = await DatabaseHelper().database;
    return await db.query(DatabaseHelper().tableName);
  }

  //Update Task
  static Future<int> updateTask(
      {required int id, required Map<String, dynamic> row}) async {
    final Database db = await DatabaseHelper().database;
    return await db.update(
      DatabaseHelper().tableName,
      row,
      where: '${DatabaseHelper().columnId} = ?',
      whereArgs: [id],
    );
  }

  //delete task
  static Future<int> deleteTask({required int id}) async {
    final Database db = await DatabaseHelper().database;
    return await db.delete(
      DatabaseHelper().tableName,
      where: '${DatabaseHelper().columnId} = ?',
      whereArgs: [id],
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 2952aadb7bdf3b50ba52cec25b55bbc3720b036d
