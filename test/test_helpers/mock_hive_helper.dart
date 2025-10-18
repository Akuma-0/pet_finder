import 'package:flutter/material.dart';

/// Mock implementation of HiveHelper for testing
class MockHiveHelper {
  static final Map<String, Map<String, dynamic>> _mockBoxes = {};
  static final Map<String, dynamic> _mockData = {};

  /// Initialize mock Hive
  static Future<void> mockInitHive() async {
    // Mock initialization
    _mockBoxes.clear();
    _mockData.clear();
  }

  /// Mock opening a box
  static Future<void> mockOpenBox(String boxName) async {
    _mockBoxes[boxName] = {};
  }

  /// Mock getting a box
  static Future<MockBox> mockGetBox(String boxName) async {
    if (!_mockBoxes.containsKey(boxName)) {
      await mockOpenBox(boxName);
    }
    return MockBox(boxName);
  }

  /// Mock adding data to box
  static void mockAddDataToBox({
    required String boxName,
    required String key,
    required dynamic value,
  }) {
    final boxKey = '$boxName:$key';
    _mockData[boxKey] = value;
    debugPrint(
      "MockHiveHelper : setData with key : $key and value : ${value.toString()} in box : $boxName",
    );
  }

  /// Mock getting data from box
  static Future<dynamic> mockGetDataFromBox({
    required String boxName,
    required String key,
  }) async {
    final boxKey = '$boxName:$key';
    final data = _mockData[boxKey];
    debugPrint(
      "MockHiveHelper : getData with key : $key and value : $data in box : $boxName",
    );
    return data;
  }

  /// Mock removing data from box
  static void mockRemoveDataFromBox({
    required String boxName,
    required String key,
  }) {
    final boxKey = '$boxName:$key';
    _mockData.remove(boxKey);
    debugPrint("MockHiveHelper : removeData with key : $key in box : $boxName");
  }

  /// Reset all mock data
  void reset() {
    _mockBoxes.clear();
    _mockData.clear();
  }

  /// Get all stored data for testing
  static Map<String, dynamic> getAllData() {
    return Map<String, dynamic>.from(_mockData);
  }

  /// Check if a key exists
  static bool containsKey(String boxName, String key) {
    final boxKey = '$boxName:$key';
    return _mockData.containsKey(boxKey);
  }
}

/// Mock Box implementation
class MockBox {
  final String _boxName;

  MockBox(this._boxName);

  void put(String key, dynamic value) {
    final boxKey = '$_boxName:$key';
    MockHiveHelper._mockData[boxKey] = value;
  }

  dynamic get(String key) {
    final boxKey = '$_boxName:$key';
    return MockHiveHelper._mockData[boxKey];
  }

  void delete(String key) {
    final boxKey = '$_boxName:$key';
    MockHiveHelper._mockData.remove(boxKey);
  }

  bool containsKey(String key) {
    final boxKey = '$_boxName:$key';
    return MockHiveHelper._mockData.containsKey(boxKey);
  }

  List<dynamic> get values {
    return MockHiveHelper._mockData.values
        .where((entry) => entry.toString().startsWith('$_boxName:'))
        .toList();
  }

  List<String> get keys {
    return MockHiveHelper._mockData.keys
        .where((key) => key.startsWith('$_boxName:'))
        .map((key) => key.substring(_boxName.length + 1))
        .toList();
  }
}
