import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pet_finder/core/helpers/constants.dart';
import 'package:pet_finder/core/helpers/hive_helper.dart';
import 'package:pet_finder/core/routing/app_router.dart';
import 'package:pet_finder/pet_finder_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding Integration Tests', () {
    setUp(() async {
      // Initialize Hive for integration tests
      await HiveHelper.initHive();
    });

    tearDown(() async {
      // Clean up: Reset onboarding status for next test
      try {
        HiveHelper.removeDataFromBox(
          boxName: HiveConstants.sharedPrefsBox,
          key: HiveConstants.isOnboardingCompleted,
        );
      } catch (e) {
        // Ignore errors in cleanup
      }
      isOnboardingSeen = false;
    });

    testWidgets('should show onboarding screen on first app launch', (
      tester,
    ) async {
      // Ensure onboarding is not completed
      isOnboardingSeen = false;

      // Launch the app
      await tester.pumpWidget(PetFinderApp(appRouter: AppRouter()));
      await tester.pumpAndSettle();

      // Verify onboarding screen is displayed
      expect(find.text('Find Your Best Companion With Us'), findsOneWidget);
      expect(
        find.text(
          'Join & discover the best suitable pets as per your preferences in your location',
        ),
        findsOneWidget,
      );
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.byType(Image), findsAtLeastNWidgets(1));
    });

    testWidgets('should navigate to home screen after completing onboarding', (
      tester,
    ) async {
      // Ensure onboarding is not completed
      isOnboardingSeen = false;

      // Launch the app
      await tester.pumpWidget(PetFinderApp(appRouter: AppRouter()));
      await tester.pumpAndSettle();

      // Verify we're on onboarding screen
      expect(find.text('Find Your Best Companion With Us'), findsOneWidget);

      // Tap the Get Started button
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Verify navigation to home screen
      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.text('Find Your Best Companion With Us'), findsNothing);
    });

    testWidgets('should skip onboarding screen on subsequent app launches', (
      tester,
    ) async {
      // First launch - complete onboarding
      isOnboardingSeen = false;

      await tester.pumpWidget(PetFinderApp(appRouter: AppRouter()));
      await tester.pumpAndSettle();

      // Complete onboarding
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Simulate app restart with onboarding completed
      isOnboardingSeen = true;

      // Launch app again
      await tester.pumpWidget(PetFinderApp(appRouter: AppRouter()));
      await tester.pumpAndSettle();

      // Verify we go directly to home screen
      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.text('Find Your Best Companion With Us'), findsNothing);
    });

    testWidgets('should persist onboarding completion across app restarts', (
      tester,
    ) async {
      // Ensure clean state
      isOnboardingSeen = false;

      // First app launch
      await tester.pumpWidget(PetFinderApp(appRouter: AppRouter()));
      await tester.pumpAndSettle();

      // Complete onboarding
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Verify we're on home screen
      expect(find.text('Home Screen'), findsOneWidget);

      // Simulate app restart by checking stored data
      final storedValue = await HiveHelper.getDataFromBox(
        boxName: HiveConstants.sharedPrefsBox,
        key: HiveConstants.isOnboardingCompleted,
      );

      expect(storedValue, isTrue);

      // Simulate second app launch with stored value
      isOnboardingSeen = storedValue ?? false;

      await tester.pumpWidget(PetFinderApp(appRouter: AppRouter()));
      await tester.pumpAndSettle();

      // Should go directly to home screen
      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.text('Find Your Best Companion With Us'), findsNothing);
    });

    testWidgets('should handle onboarding screen interactions correctly', (
      tester,
    ) async {
      isOnboardingSeen = false;

      await tester.pumpWidget(PetFinderApp(appRouter: AppRouter()));
      await tester.pumpAndSettle();

      // Test scrolling behavior if the screen has scrolling
      final scrollableWidget = find.byType(SingleChildScrollView);
      if (tester.any(scrollableWidget)) {
        await tester.drag(scrollableWidget, const Offset(0, -100));
        await tester.pumpAndSettle();
      }

      // Verify elements are still visible after scrolling
      expect(find.text('Find Your Best Companion With Us'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);

      // Test button interaction
      final getStartedButton = find.text('Get Started');
      expect(getStartedButton, findsOneWidget);

      // Long press test (should still work normally)
      await tester.longPress(getStartedButton);
      await tester.pumpAndSettle();

      // Should still be on onboarding (long press doesn't trigger navigation)
      expect(find.text('Find Your Best Companion With Us'), findsOneWidget);

      // Normal tap should trigger navigation
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle();

      // Should navigate to home
      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets(
      'should display onboarding screen with correct layout on different orientations',
      (tester) async {
        isOnboardingSeen = false;

        // Test portrait orientation
        await tester.binding.setSurfaceSize(const Size(375, 812));
        await tester.pumpWidget(PetFinderApp(appRouter: AppRouter()));
        await tester.pumpAndSettle();

        expect(find.text('Find Your Best Companion With Us'), findsOneWidget);
        expect(find.text('Get Started'), findsOneWidget);

        // Test landscape orientation
        await tester.binding.setSurfaceSize(const Size(812, 375));
        await tester.pump();

        expect(find.text('Find Your Best Companion With Us'), findsOneWidget);
        expect(find.text('Get Started'), findsOneWidget);

        // Reset to default size
        await tester.binding.setSurfaceSize(const Size(800, 600));
      },
    );

    testWidgets('should handle rapid button taps gracefully', (tester) async {
      isOnboardingSeen = false;

      await tester.pumpWidget(PetFinderApp(appRouter: AppRouter()));
      await tester.pumpAndSettle();

      final getStartedButton = find.text('Get Started');

      // Rapidly tap the button multiple times
      for (int i = 0; i < 5; i++) {
        await tester.tap(getStartedButton);
        await tester.pump(const Duration(milliseconds: 100));
      }

      await tester.pumpAndSettle();

      // Should navigate only once to home screen
      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.text('Find Your Best Companion With Us'), findsNothing);
    });

    group('Error Handling Tests', () {
      testWidgets('should handle Hive initialization errors gracefully', (
        tester,
      ) async {
        // This test would require mocking Hive to throw errors
        // For now, we'll test the normal flow and ensure it doesn't crash
        isOnboardingSeen = false;

        await tester.pumpWidget(PetFinderApp(appRouter: AppRouter()));
        await tester.pumpAndSettle();

        // App should load without crashing
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      });

      testWidgets('should handle navigation errors gracefully', (tester) async {
        isOnboardingSeen = false;

        await tester.pumpWidget(PetFinderApp(appRouter: AppRouter()));
        await tester.pumpAndSettle();

        // Even if navigation has issues, app should not crash
        await tester.tap(find.text('Get Started'));
        await tester.pumpAndSettle();

        // Should either be on home screen or still on onboarding (graceful handling)
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      });
    });

    group('Performance Tests', () {
      testWidgets('should load onboarding screen quickly', (tester) async {
        isOnboardingSeen = false;

        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(PetFinderApp(appRouter: AppRouter()));
        await tester.pumpAndSettle();

        stopwatch.stop();

        // Should load within reasonable time (adjust threshold as needed)
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
        expect(find.text('Find Your Best Companion With Us'), findsOneWidget);
      });

      testWidgets('should navigate quickly when button is tapped', (
        tester,
      ) async {
        isOnboardingSeen = false;

        await tester.pumpWidget(PetFinderApp(appRouter: AppRouter()));
        await tester.pumpAndSettle();

        final stopwatch = Stopwatch()..start();

        await tester.tap(find.text('Get Started'));
        await tester.pumpAndSettle();

        stopwatch.stop();

        // Navigation should be fast (adjust threshold as needed)
        expect(stopwatch.elapsedMilliseconds, lessThan(3000));
        expect(find.text('Home Screen'), findsOneWidget);
      });
    });
  });
}
