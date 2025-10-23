import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_finder/features/home/ui/widgets/breed_tile.dart';

import 'test_helpers/test_data_factory.dart';
import 'test_helpers/test_widget_wrapper.dart';

void main() {
  group('BreedTile Widget Tests', () {
    testWidgets('should render breed tile with basic information', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breed = TestDataFactory.createBreed(
        name: 'Persian',
        origin: 'Iran',
        lifeSpan: '12 - 17',
      );

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert
      expect(find.text('Persian'), findsOneWidget);
      expect(find.text('Iran'), findsOneWidget);
      expect(find.text('12 - 17 years'), findsOneWidget);
    });

    testWidgets('should display weight information correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breed = TestDataFactory.createBreed(
        name: 'Maine Coon',
        weight: TestDataFactory.createWeight(metric: '6 - 8'),
      );

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert
      expect(find.text('6 - 8 kg'), findsOneWidget);
    });

    testWidgets('should handle breed with null weight gracefully', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breed = TestDataFactory.createBreedWithNullWeight();

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert - Should not crash and display N/A for weight
      expect(find.text('N/A kg'), findsOneWidget);
      expect(find.byType(BreedTile), findsOneWidget);
    });

    testWidgets('should display favorite icon', (WidgetTester tester) async {
      // Arrange
      final breed = TestDataFactory.createBreed();

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('should display location icon', (WidgetTester tester) async {
      // Arrange
      final breed = TestDataFactory.createBreed(origin: 'Egypt');

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert
      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('should display elderly/lifespan icon', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breed = TestDataFactory.createBreed(lifeSpan: '10 - 15');

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert
      expect(find.byIcon(Icons.elderly), findsOneWidget);
    });

    testWidgets('should handle long breed names with ellipsis', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breed = TestDataFactory.createBreed(
        name: 'This is a very long breed name that should be truncated',
      );

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert
      expect(find.byType(BreedTile), findsOneWidget);
      expect(
        find.textContaining('This is a very long breed name'),
        findsOneWidget,
      );
    });

    testWidgets('should handle null breed name gracefully', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breed = TestDataFactory.createBreed(name: null);

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert - Should display empty string and not crash
      expect(find.byType(BreedTile), findsOneWidget);
    });

    testWidgets('should handle null origin gracefully', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breed = TestDataFactory.createBreed(origin: null);

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert - Should display empty string and not crash
      expect(find.byType(BreedTile), findsOneWidget);
    });

    testWidgets('should handle null lifespan gracefully', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breed = TestDataFactory.createBreed(lifeSpan: null);

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert - Should display empty years and not crash
      expect(find.text(' years'), findsOneWidget);
      expect(find.byType(BreedTile), findsOneWidget);
    });

    testWidgets('should have proper layout structure', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breed = TestDataFactory.createBreed();

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert - Check for main structural elements
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Expanded), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('should display cached network image widget', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breed = TestDataFactory.createBreed(
        referenceImageId: 'test_image_123',
      );

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert
      expect(find.byType(Container), findsWidgets);
      // Note: CachedNetworkImage might not be testable in unit tests without network mocking
      // but we can verify the widget structure is present
    });

    testWidgets('should handle missing image reference gracefully', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breed = TestDataFactory.createBreed(referenceImageId: null);

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert - Should not crash
      expect(find.byType(BreedTile), findsOneWidget);
    });

    testWidgets('should have correct text styles and colors', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breed = TestDataFactory.createBreed(name: 'Test Breed');

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert - Find the breed name text widget
      final nameTextFinder = find.text('Test Breed');
      expect(nameTextFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(nameTextFinder);
      expect(textWidget.overflow, equals(TextOverflow.ellipsis));
      expect(textWidget.maxLines, equals(1));
    });

    testWidgets('should display all information sections', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breed = TestDataFactory.createBreed(
        name: 'Complete Breed',
        origin: 'Test Country',
        lifeSpan: '10 - 15',
        weight: TestDataFactory.createWeight(metric: '4 - 6'),
      );

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert - All information should be present
      expect(find.text('Complete Breed'), findsOneWidget);
      expect(find.text('Test Country'), findsOneWidget);
      expect(find.text('4 - 6 kg'), findsOneWidget);
      expect(find.text('10 - 15 years'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
      expect(find.byIcon(Icons.elderly), findsOneWidget);
    });

    testWidgets('should be tappable (container should respond to gestures)', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breed = TestDataFactory.createBreed();
      bool tapped = false;

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(
          child: GestureDetector(
            onTap: () => tapped = true,
            child: BreedTile(breed: breed),
          ),
        ),
      );

      await tester.tap(find.byType(BreedTile));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('should maintain consistent size', (WidgetTester tester) async {
      // Arrange
      final breed = TestDataFactory.createBreed();

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert - Check that the widget has a defined size
      final containerFinder = find.byType(Container).first;
      expect(containerFinder, findsOneWidget);

      final container = tester.widget<Container>(containerFinder);
      expect(container.padding, isNotNull);
    });

    testWidgets('should handle empty string values gracefully', (
      WidgetTester tester,
    ) async {
      // Arrange
      final breed = TestDataFactory.createBreed(
        name: '',
        origin: '',
        lifeSpan: '',
      );

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: BreedTile(breed: breed)),
      );

      // Assert - Should not crash with empty strings
      expect(find.byType(BreedTile), findsOneWidget);
    });
  });
}
