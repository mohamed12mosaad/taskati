import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:taskati_app/core/models/task_model.dart';
import 'package:taskati_app/hive/hive_registrar.g.dart';

abstract class HiveHelper {
  static late Box userBox;
  static late Box<TaskModel> taskBox;

  static String userBoxKey = 'userBox';
  static String taskBoxKey = 'taskBox';

  static String nameKey = 'name';
  static String imageKey = 'image';
  static String isUploadedKey = 'isUploaded';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapters();
    userBox = await Hive.openBox(userBoxKey);
    taskBox = await Hive.openBox<TaskModel>(taskBoxKey);
  }

  static Future<void> setUserData(String name, String image) async {
    await userBox.put(nameKey, name);
    await userBox.put(imageKey, image);
  }

  static Future<void> cacheData(String key, dynamic value) async {
    await userBox.put(key, value);
  }

  static dynamic getData(String key) {
    return userBox.get(key);
  }

  static Future<void> cacheTask(String key, TaskModel value) async {
    await taskBox.put(key, value);
  }

  static TaskModel? getTask(String key) {
    return taskBox.get(key);
  }
}