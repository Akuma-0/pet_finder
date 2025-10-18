import 'package:flutter_test/flutter_test.dart';
import 'package:pet_finder/core/helpers/constants.dart';

import 'test_helpers/mock_hive_helper.dart';

void main() {
  group('Onboarding Logic Unit Tests', () {
    late MockHiveHelper mockHiveHelper;

    setUp(() {
      mockHiveHelper = MockHiveHelper();
      // Reset the global variable
      isOnboardingSeen = false;
    });

    tearDown(() {
      mockHiveHelper.reset();
    });

    group('Constants Tests', () {
      test('should have correct Hive constants', () {
        expect(HiveConstants.sharedPrefsBox, 'sharedPreferencesBox');
        expect(HiveConstants.isOnboardingCompleted, 'isOnboardingCompleted');
      });

      test('should have correct initial onboarding state', () {
        expect(isOnboardingSeen, isFalse);
      });

      test('should be able to modify onboarding state', () {
        isOnboardingSeen = true;
        expect(isOnboardingSeen, isTrue);

        isOnboardingSeen = false;
        expect(isOnboardingSeen, isFalse);
      });
    });

    group('HiveHelper Mock Tests', () {
      test('should initialize Hive correctly', () async {
        await MockHiveHelper.mockInitHive();
        expect(MockHiveHelper.getAllData(), isEmpty);
      });

      test('should store and retrieve onboarding completion status', () async {
        const boxName = HiveConstants.sharedPrefsBox;
        const key = HiveConstants.isOnboardingCompleted;
        const value = true;

        // Store data
        MockHiveHelper.mockAddDataToBox(
          boxName: boxName,
          key: key,
          value: value,
        );

        // Retrieve data
        final retrievedValue = await MockHiveHelper.mockGetDataFromBox(
          boxName: boxName,
          key: key,
        );

        expect(retrievedValue, value);
        expect(MockHiveHelper.containsKey(boxName, key), isTrue);
      });

      test('should return null for non-existent keys', () async {
        const boxName = HiveConstants.sharedPrefsBox;
        const key = 'non_existent_key';

        final retrievedValue = await MockHiveHelper.mockGetDataFromBox(
          boxName: boxName,
          key: key,
        );

        expect(retrievedValue, isNull);
        expect(MockHiveHelper.containsKey(boxName, key), isFalse);
      });

      test('should remove data correctly', () async {
        const boxName = HiveConstants.sharedPrefsBox;
        const key = HiveConstants.isOnboardingCompleted;
        const value = true;

        // Store data
        MockHiveHelper.mockAddDataToBox(
          boxName: boxName,
          key: key,
          value: value,
        );

        // Verify data exists
        expect(MockHiveHelper.containsKey(boxName, key), isTrue);

        // Remove data
        MockHiveHelper.mockRemoveDataFromBox(boxName: boxName, key: key);

        // Verify data is removed
        expect(MockHiveHelper.containsKey(boxName, key), isFalse);

        final retrievedValue = await MockHiveHelper.mockGetDataFromBox(
          boxName: boxName,
          key: key,
        );
        expect(retrievedValue, isNull);
      });

      test('should handle multiple boxes correctly', () async {
        const box1 = 'box1';
        const box2 = 'box2';
        const key = 'test_key';
        const value1 = 'value1';
        const value2 = 'value2';

        // Store data in different boxes
        MockHiveHelper.mockAddDataToBox(boxName: box1, key: key, value: value1);

        MockHiveHelper.mockAddDataToBox(boxName: box2, key: key, value: value2);

        // Retrieve data from different boxes
        final retrievedValue1 = await MockHiveHelper.mockGetDataFromBox(
          boxName: box1,
          key: key,
        );

        final retrievedValue2 = await MockHiveHelper.mockGetDataFromBox(
          boxName: box2,
          key: key,
        );

        expect(retrievedValue1, value1);
        expect(retrievedValue2, value2);
        expect(MockHiveHelper.containsKey(box1, key), isTrue);
        expect(MockHiveHelper.containsKey(box2, key), isTrue);
      });

      test('should handle different data types', () async {
        const boxName = HiveConstants.sharedPrefsBox;

        // Test boolean
        MockHiveHelper.mockAddDataToBox(
          boxName: boxName,
          key: 'bool_key',
          value: true,
        );

        // Test string
        MockHiveHelper.mockAddDataToBox(
          boxName: boxName,
          key: 'string_key',
          value: 'test_string',
        );

        // Test integer
        MockHiveHelper.mockAddDataToBox(
          boxName: boxName,
          key: 'int_key',
          value: 42,
        );

        // Test double
        MockHiveHelper.mockAddDataToBox(
          boxName: boxName,
          key: 'double_key',
          value: 3.14,
        );

        // Test list
        MockHiveHelper.mockAddDataToBox(
          boxName: boxName,
          key: 'list_key',
          value: [1, 2, 3],
        );

        // Test map
        MockHiveHelper.mockAddDataToBox(
          boxName: boxName,
          key: 'map_key',
          value: {'key': 'value'},
        );

        // Verify all data types
        expect(
          await MockHiveHelper.mockGetDataFromBox(
            boxName: boxName,
            key: 'bool_key',
          ),
          true,
        );
        expect(
          await MockHiveHelper.mockGetDataFromBox(
            boxName: boxName,
            key: 'string_key',
          ),
          'test_string',
        );
        expect(
          await MockHiveHelper.mockGetDataFromBox(
            boxName: boxName,
            key: 'int_key',
          ),
          42,
        );
        expect(
          await MockHiveHelper.mockGetDataFromBox(
            boxName: boxName,
            key: 'double_key',
          ),
          3.14,
        );
        expect(
          await MockHiveHelper.mockGetDataFromBox(
            boxName: boxName,
            key: 'list_key',
          ),
          [1, 2, 3],
        );
        expect(
          await MockHiveHelper.mockGetDataFromBox(
            boxName: boxName,
            key: 'map_key',
          ),
          {'key': 'value'},
        );
      });

      test('should overwrite existing data', () async {
        const boxName = HiveConstants.sharedPrefsBox;
        const key = HiveConstants.isOnboardingCompleted;

        // Store initial value
        MockHiveHelper.mockAddDataToBox(
          boxName: boxName,
          key: key,
          value: false,
        );

        var retrievedValue = await MockHiveHelper.mockGetDataFromBox(
          boxName: boxName,
          key: key,
        );
        expect(retrievedValue, false);

        // Overwrite with new value
        MockHiveHelper.mockAddDataToBox(
          boxName: boxName,
          key: key,
          value: true,
        );

        retrievedValue = await MockHiveHelper.mockGetDataFromBox(
          boxName: boxName,
          key: key,
        );
        expect(retrievedValue, true);
      });
    });

    group('Onboarding Flow Logic Tests', () {
      test('should simulate complete onboarding flow', () async {
        // Initial state - onboarding not seen
        expect(isOnboardingSeen, isFalse);

        // Simulate checking if onboarding was seen (first app launch)
        var onboardingData = await MockHiveHelper.mockGetDataFromBox(
          boxName: HiveConstants.sharedPrefsBox,
          key: HiveConstants.isOnboardingCompleted,
        );

        isOnboardingSeen = onboardingData ?? false;
        expect(isOnboardingSeen, isFalse);

        // Simulate user completing onboarding
        MockHiveHelper.mockAddDataToBox(
          boxName: HiveConstants.sharedPrefsBox,
          key: HiveConstants.isOnboardingCompleted,
          value: true,
        );

        // Simulate next app launch - checking onboarding status
        onboardingData = await MockHiveHelper.mockGetDataFromBox(
          boxName: HiveConstants.sharedPrefsBox,
          key: HiveConstants.isOnboardingCompleted,
        );

        isOnboardingSeen = onboardingData ?? false;
        expect(isOnboardingSeen, isTrue);
      });

      test('should handle corrupted onboarding data gracefully', () async {
        // Store invalid data type
        MockHiveHelper.mockAddDataToBox(
          boxName: HiveConstants.sharedPrefsBox,
          key: HiveConstants.isOnboardingCompleted,
          value: 'invalid_boolean_string',
        );

        final onboardingData = await MockHiveHelper.mockGetDataFromBox(
          boxName: HiveConstants.sharedPrefsBox,
          key: HiveConstants.isOnboardingCompleted,
        );

        // Should handle gracefully with default value
        isOnboardingSeen = (onboardingData is bool) ? onboardingData : false;
        expect(isOnboardingSeen, isFalse);
      });
    });
  });
}
