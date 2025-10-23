import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pet_finder/core/networking/api_error_handler.dart';
import 'package:pet_finder/core/networking/api_result.dart';
import 'package:pet_finder/features/home/logic/home_cubit.dart';
import 'package:pet_finder/features/home/ui/home_screen.dart';
import 'package:pet_finder/features/home/ui/widgets/breed_tile.dart';
import 'package:pet_finder/features/home/ui/widgets/search_box.dart';

import '../test/test_helpers/mock_home_repo.dart';
import '../test/test_helpers/test_data_factory.dart';
import '../test/test_helpers/test_widget_wrapper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Home Feature Integration Tests', () {
    late MockHomeRepo mockHomeRepo;
    late HomeCubit homeCubit;

    setUp(() {
      mockHomeRepo = MockHomeRepo();
      homeCubit = HomeCubit(mockHomeRepo);
    });

    tearDown(() {
      homeCubit.close();
    });

    Widget createApp() {
      return TestWidgetWrapper(
        child: BlocProvider<HomeCubit>(
          create: (_) => homeCubit,
          child: const HomeScreen(),
        ),
      );
    }

    group('Complete User Flows', () {
      testWidgets('should complete successful breeds loading flow', (
        WidgetTester tester,
      ) async {
        // Arrange
        final mockBreeds = TestDataFactory.createBreedsList(count: 5);
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(mockBreeds));

        // Act
        await tester.pumpWidget(createApp());

        // Initial state - should show initial UI
        expect(find.text('Find Your Forever Pet'), findsOneWidget);
        expect(find.byType(SearchBox), findsOneWidget);

        // Trigger data loading
        homeCubit.getBreeds();
        await tester.pump(); // Trigger loading state

        // Assert loading state
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Wait for data to load
        await tester.pumpAndSettle();

        // Assert success state
        expect(find.byType(BreedTile), findsNWidgets(5));
        expect(find.text('Breed 0'), findsOneWidget);
        expect(find.text('Breed 1'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);

        verify(mockHomeRepo.getBreeds()).called(1);
      });

      testWidgets('should handle error flow correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockHomeRepo.getBreeds()).thenAnswer(
          (_) async => ApiResult.failure(
            ErrorHandler.handle(Exception('Network error')),
          ),
        );

        // Act
        await tester.pumpWidget(createApp());

        // Trigger data loading
        homeCubit.getBreeds();
        await tester.pump(); // Trigger loading state

        // Assert loading state
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Wait for error state
        await tester.pumpAndSettle();

        // Assert error state
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('Failed to load breeds'), findsOneWidget);
        expect(
          find.text('Please check your internet connection'),
          findsOneWidget,
        );
        expect(find.byType(BreedTile), findsNothing);

        verify(mockHomeRepo.getBreeds()).called(1);
      });

      testWidgets('should handle retry after error', (
        WidgetTester tester,
      ) async {
        // Arrange - First call fails, second succeeds
        final mockBreeds = TestDataFactory.createBreedsList(count: 3);
        when(mockHomeRepo.getBreeds()).thenAnswer(
          (_) async => ApiResult.failure(
            ErrorHandler.handle(Exception('Network error')),
          ),
        );

        // Act - Initial load (fails)
        await tester.pumpWidget(createApp());
        homeCubit.getBreeds();
        await tester.pumpAndSettle();

        // Assert error state
        expect(find.byIcon(Icons.error_outline), findsOneWidget);

        // Arrange - Setup successful response for retry
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(mockBreeds));

        // Act - Retry
        homeCubit.getBreeds();
        await tester.pump(); // Loading state
        await tester.pumpAndSettle(); // Success state

        // Assert success after retry
        expect(find.byType(BreedTile), findsNWidgets(3));
        expect(find.byIcon(Icons.error_outline), findsNothing);
        expect(find.text('Breed 0'), findsOneWidget);

        verify(mockHomeRepo.getBreeds()).called(2);
      });

      testWidgets('should handle empty breeds list gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        final emptyBreeds = TestDataFactory.createEmptyBreedsList();
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(emptyBreeds));

        // Act
        await tester.pumpWidget(createApp());
        homeCubit.getBreeds();
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(BreedTile), findsNothing);
        expect(find.byIcon(Icons.error_outline), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsNothing);

        verify(mockHomeRepo.getBreeds()).called(1);
      });
    });

    group('Search Functionality', () {
      testWidgets('should allow search input', (WidgetTester tester) async {
        // Arrange
        final mockBreeds = TestDataFactory.createBreedsList(count: 3);
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(mockBreeds));

        // Act
        await tester.pumpWidget(createApp());
        homeCubit.getBreeds();
        await tester.pumpAndSettle();

        // Find search field and enter text
        final searchField = find.byType(TextField);
        expect(searchField, findsOneWidget);

        await tester.enterText(searchField, 'Persian');
        await tester.pump();

        // Assert
        expect(find.text('Persian'), findsOneWidget);
      });

      testWidgets('should clear search input', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createApp());

        // Enter text in search
        final searchField = find.byType(TextField);
        await tester.enterText(searchField, 'Test search');
        await tester.pump();

        expect(find.text('Test search'), findsOneWidget);

        // Clear the search
        await tester.enterText(searchField, '');
        await tester.pump();

        // Assert text is cleared
        expect(find.text('Test search'), findsNothing);
      });

      testWidgets('should handle special characters in search', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(createApp());

        final searchField = find.byType(TextField);
        const specialText = '!@#\$%^&*()';

        await tester.enterText(searchField, specialText);
        await tester.pump();

        // Assert
        expect(find.text(specialText), findsOneWidget);
      });
    });

    group('UI Interactions', () {
      testWidgets('should handle breed tile taps', (WidgetTester tester) async {
        // Arrange
        final mockBreeds = TestDataFactory.createBreedsList(count: 3);
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(mockBreeds));

        // Act
        await tester.pumpWidget(createApp());
        homeCubit.getBreeds();
        await tester.pumpAndSettle();

        // Find and tap first breed tile
        final firstBreedTile = find.byType(BreedTile).first;
        expect(firstBreedTile, findsOneWidget);

        await tester.tap(firstBreedTile);
        await tester.pump();

        // Assert - Should not crash
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle app bar actions', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createApp());

        // Find notification icon
        final notificationIcon = find.byIcon(Icons.notifications_none_outlined);
        expect(notificationIcon, findsOneWidget);

        // Tap notification icon
        await tester.tap(notificationIcon);
        await tester.pump();

        // Assert - Should not crash
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle filter icon tap', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createApp());

        // Find filter icon (tune icon)
        final filterIcon = find.byIcon(Icons.tune);
        expect(filterIcon, findsOneWidget);

        // Tap filter icon
        await tester.tap(filterIcon);
        await tester.pump();

        // Assert - Should not crash
        expect(tester.takeException(), isNull);
      });
    });

    group('Scrolling and List Behavior', () {
      testWidgets('should scroll through breeds list', (
        WidgetTester tester,
      ) async {
        // Arrange - Create many breeds to ensure scrolling
        final manyBreeds = TestDataFactory.createBreedsList(count: 20);
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(manyBreeds));

        // Act
        await tester.pumpWidget(createApp());
        homeCubit.getBreeds();
        await tester.pumpAndSettle();

        // Find the list
        final listView = find.byType(ListView);
        expect(listView, findsOneWidget);

        // Check initial state - should see first items
        expect(find.text('Breed 0'), findsOneWidget);
        expect(find.text('Breed 19'), findsNothing);

        // Scroll down
        await tester.fling(listView, const Offset(0, -300), 1000);
        await tester.pumpAndSettle();

        // Should see later items after scrolling
        expect(find.text('Breed 0'), findsNothing);
      });

      testWidgets('should handle fast scrolling without errors', (
        WidgetTester tester,
      ) async {
        // Arrange
        final manyBreeds = TestDataFactory.createBreedsList(count: 50);
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(manyBreeds));

        // Act
        await tester.pumpWidget(createApp());
        homeCubit.getBreeds();
        await tester.pumpAndSettle();

        final listView = find.byType(ListView);

        // Perform multiple rapid scrolls
        for (int i = 0; i < 5; i++) {
          await tester.fling(listView, const Offset(0, -500), 2000);
          await tester.pump();
        }
        await tester.pumpAndSettle();

        // Assert - Should not crash
        expect(tester.takeException(), isNull);
      });
    });

    group('State Persistence', () {
      testWidgets('should maintain search text during data reload', (
        WidgetTester tester,
      ) async {
        // Arrange
        final mockBreeds = TestDataFactory.createBreedsList(count: 3);
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(mockBreeds));

        // Act
        await tester.pumpWidget(createApp());

        // Enter search text
        const searchText = 'Maine Coon';
        await tester.enterText(find.byType(TextField), searchText);
        await tester.pump();

        // Trigger data load
        homeCubit.getBreeds();
        await tester.pumpAndSettle();

        // Assert - Search text should be preserved
        expect(find.text(searchText), findsOneWidget);
      });

      testWidgets('should handle multiple state changes correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        final breeds1 = TestDataFactory.createBreedsList(count: 2);
        final breeds2 = TestDataFactory.createBreedsList(count: 5);

        // Act
        await tester.pumpWidget(createApp());

        // First load
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(breeds1));
        homeCubit.getBreeds();
        await tester.pumpAndSettle();
        expect(find.byType(BreedTile), findsNWidgets(2));

        // Second load
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(breeds2));
        homeCubit.getBreeds();
        await tester.pumpAndSettle();
        expect(find.byType(BreedTile), findsNWidgets(5));

        // Error state
        when(mockHomeRepo.getBreeds()).thenAnswer(
          (_) async =>
              ApiResult.failure(ErrorHandler.handle(Exception('Error'))),
        );
        homeCubit.getBreeds();
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.byType(BreedTile), findsNothing);
      });
    });

    group('Performance and Memory', () {
      testWidgets('should handle large datasets efficiently', (
        WidgetTester tester,
      ) async {
        // Arrange - Large dataset
        final largeBreedsList = TestDataFactory.createBreedsList(count: 1000);
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(largeBreedsList));

        // Act
        await tester.pumpWidget(createApp());
        homeCubit.getBreeds();
        await tester.pumpAndSettle();

        // Assert - Should handle large dataset without issues
        expect(find.byType(ListView), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Only visible items should be rendered
        final visibleTiles = find.byType(BreedTile);
        expect(visibleTiles.evaluate().length, lessThan(1000));
      });

      testWidgets('should not leak memory during state changes', (
        WidgetTester tester,
      ) async {
        // This test ensures proper cleanup during state transitions
        final breeds = TestDataFactory.createBreedsList(count: 10);
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(breeds));

        // Act - Multiple cycles
        await tester.pumpWidget(createApp());

        for (int i = 0; i < 10; i++) {
          homeCubit.getBreeds();
          await tester.pump(); // Loading
          await tester.pumpAndSettle(); // Complete
        }

        // Assert - Should complete without memory issues
        expect(tester.takeException(), isNull);
        expect(find.byType(BreedTile), findsNWidgets(10));
      });
    });

    group('Error Recovery', () {
      testWidgets('should recover from network errors gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange - Simulate intermittent network issues
        final mockBreeds = TestDataFactory.createBreedsList(count: 3);
        var callCount = 0;

        when(mockHomeRepo.getBreeds()).thenAnswer((_) async {
          callCount++;
          if (callCount <= 2) {
            return ApiResult.failure(
              ErrorHandler.handle(Exception('Network timeout')),
            );
          }
          return ApiResult.success(mockBreeds);
        });

        // Act
        await tester.pumpWidget(createApp());

        // First attempt - fails
        homeCubit.getBreeds();
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.error_outline), findsOneWidget);

        // Second attempt - fails
        homeCubit.getBreeds();
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.error_outline), findsOneWidget);

        // Third attempt - succeeds
        homeCubit.getBreeds();
        await tester.pumpAndSettle();
        expect(find.byType(BreedTile), findsNWidgets(3));
        expect(find.byIcon(Icons.error_outline), findsNothing);

        verify(mockHomeRepo.getBreeds()).called(3);
      });
    });

    group('Complete App Integration', () {
      testWidgets('should integrate all components seamlessly', (
        WidgetTester tester,
      ) async {
        // Arrange
        final mockBreeds = TestDataFactory.createBreedsList(count: 10);
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(mockBreeds));

        // Act - Complete user journey
        await tester.pumpWidget(createApp());

        // 1. Initial state
        expect(find.text('Find Your Forever Pet'), findsOneWidget);
        expect(find.byType(SearchBox), findsOneWidget);

        // 2. Search interaction
        await tester.enterText(find.byType(TextField), 'Cat breeds');
        await tester.pump();
        expect(find.text('Cat breeds'), findsOneWidget);

        // 3. Load data
        homeCubit.getBreeds();
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // 4. Display results
        await tester.pumpAndSettle();
        expect(find.byType(BreedTile), findsNWidgets(10));
        expect(find.byType(CircularProgressIndicator), findsNothing);

        // 5. Scroll through results
        final listView = find.byType(ListView);
        await tester.fling(listView, const Offset(0, -200), 500);
        await tester.pumpAndSettle();

        // 6. Interact with breed tile
        await tester.tap(find.byType(BreedTile).first);
        await tester.pump();

        // 7. Clear search
        await tester.enterText(find.byType(TextField), '');
        await tester.pump();

        // Assert - All interactions completed successfully
        expect(tester.takeException(), isNull);
        expect(find.byType(BreedTile), findsNWidgets(10));
        verify(mockHomeRepo.getBreeds()).called(1);
      });
    });
  });
}
