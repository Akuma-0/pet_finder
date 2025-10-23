import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_finder/features/home/ui/widgets/breed_tile.dart';
import 'package:pet_finder/features/home/ui/widgets/breeds_list_view.dart';

import 'test_helpers/test_data_factory.dart';
import 'test_helpers/test_widget_wrapper.dart';

void main() {
  group('BreedsListView Widget Tests', () {
    testWidgets('should render empty list when no breeds provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      final emptyBreeds = TestDataFactory.createEmptyBreedsList();

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedsListView(breeds: emptyBreeds)),
      );

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(BreedTile), findsNothing);
    });

    testWidgets('should render single breed tile when one breed provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      final singleBreed = [TestDataFactory.createBreed(name: 'Single Breed')];

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedsListView(breeds: singleBreed)),
      );

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(BreedTile), findsOneWidget);
      expect(find.text('Single Breed'), findsOneWidget);
    });

    testWidgets(
      'should render multiple breed tiles when multiple breeds provided',
      (WidgetTester tester) async {
        // Arrange
        final multipleBreeds = TestDataFactory.createBreedsList(count: 5);

        // Act
        await tester.pumpWidget(
          SimpleTestWrapper(child: BreedsListView(breeds: multipleBreeds)),
        );

        // Assert
        expect(find.byType(ListView), findsOneWidget);
        expect(
          find.byType(BreedTile),
          findsWidgets,
        ); // At least one, but may not be all due to viewport

        // Check that we can scroll through to see more items
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pumpAndSettle();

        // Verify ListView itemCount property
        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView.childrenDelegate.estimatedChildCount, 5);
      },
    );

    testWidgets('should use ListView.builder for performance', (
      WidgetTester tester,
    ) async {
      // Arrange
      final manyBreeds = TestDataFactory.createBreedsList(count: 10);

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedsListView(breeds: manyBreeds)),
      );

      // Assert
      expect(find.byType(ListView), findsOneWidget);

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(
        listView.itemExtent,
        isNull,
      ); // Using builder, not with fixed extent
    });

    testWidgets('should be scrollable when content exceeds viewport', (
      WidgetTester tester,
    ) async {
      // Arrange
      final manyBreeds = TestDataFactory.createBreedsList(count: 20);

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(
          child: SizedBox(
            height: 400, // Constrain height to force scrolling
            child: BreedsListView(breeds: manyBreeds),
          ),
        ),
      );

      // Initial state - should see first few items
      expect(find.text('Breed 0'), findsOneWidget);
      expect(find.text('Breed 19'), findsNothing);

      // Scroll to bottom
      await tester.fling(find.byType(ListView), const Offset(0, -300), 1000);
      await tester.pumpAndSettle();

      // Should now see later items
      expect(find.text('Breed 0'), findsNothing);
      // Note: Exact visibility depends on item height and viewport size
    });

    testWidgets('should maintain correct item count', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breeds = TestDataFactory.createBreedsList(count: 7);

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedsListView(breeds: breeds)),
      );

      // Assert - Check ListView properties rather than rendered widgets
      expect(find.byType(ListView), findsOneWidget);
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.childrenDelegate.estimatedChildCount, 7);

      // Check that some BreedTiles are rendered (at least what's visible)
      expect(find.byType(BreedTile), findsWidgets);
    });

    testWidgets('should handle breeds with different data gracefully', (
      WidgetTester tester,
    ) async {
      // Arrange
      final diverseBreeds = [
        TestDataFactory.createBreed(
          name: 'Complete Breed',
          origin: 'Country A',
        ),
        TestDataFactory.createBreedWithNullWeight(),
        TestDataFactory.createMinimalBreed(),
        TestDataFactory.createBreed(name: null, origin: null),
      ];

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedsListView(breeds: diverseBreeds)),
      );

      // Assert - Should render without crashing
      expect(find.byType(BreedTile), findsWidgets);
      expect(find.byType(ListView), findsOneWidget);

      // Check that ListView has correct item count
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.childrenDelegate.estimatedChildCount, 4);
    });

    testWidgets('should render tiles in correct order', (
      WidgetTester tester,
    ) async {
      // Arrange
      final orderedBreeds = [
        TestDataFactory.createBreed(name: 'First Breed'),
        TestDataFactory.createBreed(name: 'Second Breed'),
        TestDataFactory.createBreed(name: 'Third Breed'),
      ];

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedsListView(breeds: orderedBreeds)),
      );

      // Assert - Check order by finding text widgets and comparing their positions
      final firstBreedFinder = find.text('First Breed');
      final secondBreedFinder = find.text('Second Breed');
      final thirdBreedFinder = find.text('Third Breed');

      expect(firstBreedFinder, findsOneWidget);
      expect(secondBreedFinder, findsOneWidget);
      expect(thirdBreedFinder, findsOneWidget);

      // Get the positions to verify order
      final firstBreedY = tester.getTopLeft(firstBreedFinder).dy;
      final secondBreedY = tester.getTopLeft(secondBreedFinder).dy;
      final thirdBreedY = tester.getTopLeft(thirdBreedFinder).dy;

      expect(firstBreedY, lessThan(secondBreedY));
      expect(secondBreedY, lessThan(thirdBreedY));
    });

    testWidgets('should handle breed updates correctly', (
      WidgetTester tester,
    ) async {
      // Arrange - Initial breeds
      final initialBreeds = TestDataFactory.createBreedsList(count: 3);

      // Act - Render initial list
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedsListView(breeds: initialBreeds)),
      );

      // Assert initial state
      expect(find.byType(BreedTile), findsWidgets);
      final initialListView = tester.widget<ListView>(find.byType(ListView));
      expect(initialListView.childrenDelegate.estimatedChildCount, 3);

      // Arrange - Updated breeds
      final updatedBreeds = TestDataFactory.createBreedsList(count: 5);

      // Act - Update the list
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedsListView(breeds: updatedBreeds)),
      );

      // Assert updated state
      final updatedListView = tester.widget<ListView>(find.byType(ListView));
      expect(updatedListView.childrenDelegate.estimatedChildCount, 5);
    });

    testWidgets('should have proper key for widget identification', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breeds = TestDataFactory.createBreedsList(count: 2);

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(
          child: BreedsListView(breeds: breeds, key: const Key('breeds_list')),
        ),
      );

      // Assert
      expect(find.byKey(const Key('breeds_list')), findsOneWidget);
    });

    testWidgets('should not overflow with long breed lists', (
      WidgetTester tester,
    ) async {
      // Arrange
      final longBreedsList = TestDataFactory.createBreedsList(count: 100);

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(
          child: SizedBox(
            height: 600,
            child: BreedsListView(breeds: longBreedsList),
          ),
        ),
      );

      // Assert - Should not throw overflow exceptions
      expect(find.byType(ListView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle rapid list updates without errors', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breeds1 = TestDataFactory.createBreedsList(count: 3);
      final breeds2 = TestDataFactory.createBreedsList(count: 7);
      final breeds3 = TestDataFactory.createEmptyBreedsList();

      // Act - Rapid updates
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedsListView(breeds: breeds1)),
      );

      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedsListView(breeds: breeds2)),
      );

      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedsListView(breeds: breeds3)),
      );

      await tester.pump();

      // Assert - Final state should be empty
      expect(find.byType(BreedTile), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should support accessibility features', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breeds = TestDataFactory.createBreedsList(count: 3);

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedsListView(breeds: breeds)),
      );

      // Assert - ListView should have semantic properties
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.semanticChildCount, equals(3));
    });

    testWidgets('should handle memory efficiently with large lists', (
      WidgetTester tester,
    ) async {
      // Arrange
      final largeBreedsList = TestDataFactory.createBreedsList(count: 1000);

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(
          child: SizedBox(
            height: 400,
            child: BreedsListView(breeds: largeBreedsList),
          ),
        ),
      );

      // Assert - Should use ListView.builder for efficient memory usage
      expect(find.byType(ListView), findsOneWidget);

      // Only visible items should be rendered initially
      final visibleTiles = find.byType(BreedTile);
      expect(visibleTiles.evaluate().length, lessThan(1000));
    });
  });
}
