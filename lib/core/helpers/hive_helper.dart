import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveHelper {
  static Future<void> initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  static Future<void> openBox(String boxName) async {
    await Hive.openBox(boxName);
  }

  static Future<Box<dynamic>> getBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await openBox(boxName);
    }
    return Hive.box(boxName);
  }

  static void addDataToBox({
    required String boxName,
    required String key,
    required dynamic value,
  }) async {
    final box = await getBox(boxName);
    debugPrint(
      "HiveHelper : setData with key : $key and value : ${value.toString()} in box : $boxName",
    );
    box.put(key, value);
  }

  static Future<dynamic> getDataFromBox({
    required String boxName,
    required String key,
  }) async {
    final box = await getBox(boxName);
    final data = box.get(key);
    debugPrint(
      "HiveHelper : getData with key : $key and value : $data in box : $boxName",
    );
    return data;
  }

  static void removeDataFromBox({
    required String boxName,
    required String key,
  }) async {
    final box = await getBox(boxName);
    debugPrint("HiveHelper : removeData with key : $key in box : $boxName");
    box.delete(key);
  }
}
