import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:taskati_app/core/models/task_model.dart';

class DatabaseHelper {
  static late Database db;
  static final Map<String, dynamic> _userSettingsCache = {};
  
  // ValueNotifier to trigger UI updates when tasks change
  static final ValueNotifier<List<TaskModel>> tasksNotifier = ValueNotifier([]);

  static const String userBoxKey = 'userBox';
  static const String taskBoxKey = 'taskBox';

  static const String nameKey = 'name';
  static const String imageKey = 'image';
  static const String isUploadedKey = 'isUploaded';
  static const String isDarkModeKey = 'isDarkMode';

  static Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'taskati.db');

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            date TEXT,
            startTime TEXT,
            endTime TEXT,
            isCompleted INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE user_settings (
            key TEXT PRIMARY KEY,
            value TEXT
          )
        ''');
      },
    );

    await _loadUserSettings();
    await _loadTasks();
  }

  // --- User Settings Cache ---

  static Future<void> _loadUserSettings() async {
    final List<Map<String, dynamic>> maps = await db.query('user_settings');
    for (var map in maps) {
      _userSettingsCache[map['key']] = map['value'];
    }
  }

  static dynamic getData(String key) {
    var value = _userSettingsCache[key];
    if (value == null) return null;
    
    // Parse known boolean types since SQLite stores them as strings
    if (key == isDarkModeKey || key == isUploadedKey) {
      return value == 'true';
    }
    return value;
  }

  static Future<void> cacheData(String key, dynamic value) async {
    _userSettingsCache[key] = value.toString();
    await db.insert(
      'user_settings',
      {'key': key, 'value': value.toString()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> setUserData(String name, String image) async {
    await cacheData(nameKey, name);
    await cacheData(imageKey, image);
  }

  // --- Tasks CRUD ---

  static Future<void> _loadTasks() async {
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    final tasks = maps.map((map) => TaskModel.fromMap(map)).toList();
    tasksNotifier.value = tasks;
  }

  static Future<void> cacheTask(String key, TaskModel task) async {
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _loadTasks();
  }

  static Future<void> updateTask(TaskModel task) async {
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    await _loadTasks();
  }

  static Future<void> deleteTask(String id) async {
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    await _loadTasks();
  }

  static TaskModel? getTask(String key) {
    try {
      return tasksNotifier.value.firstWhere((task) => task.id == key);
    } catch (e) {
      return null;
    }
  }
}
