import 'package:database_intro/Models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance; //cash database instance

  final String tableuser = "userTable";
  final String columnId = "id";
  final String columnUserName = "username";
  final String coloumnPassword = "password";
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "maindb.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $tableuser "
        "($columnId INTEGER PRIMARY KEY, $columnUserName TEXT, $coloumnPassword TEXT)");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableuser", user.toMap());
    return res;
  }

  Future<List> getAllUsers() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableuser");
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("Select Count(*) from $tableuser"));
  }

  Future<User> getuser(int id) async {
    var dbClient = await db;
    var result =
        await dbClient.rawQuery("SELECT * FROM $tableuser where $columnId=$id");
    if (result.length == 0) {
      return null;
    } else {
      return new User.fromMap(result.first);
    }
  }

  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableuser, where: "$columnId=?", whereArgs: [id]);
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return await dbClient.update(tableuser, user.toMap(),
        where: "$columnId=?", whereArgs: [user.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
