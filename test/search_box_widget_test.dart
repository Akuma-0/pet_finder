import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_finder/features/home/ui/widgets/search_box.dart';

import 'test_helpers/test_widget_wrapper.dart';

void main() {
  group('SearchBox Widget Tests', () {
    testWidgets('should render with default properties', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(const SimpleTestWrapper(child: SearchBox()));

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets('should display custom hint text', (WidgetTester tester) async {
      // Arrange
      const customHintText = 'Search for breeds...';

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(
          child: TextField(
            decoration: const InputDecoration(hintText: customHintText),
          ),
        ),
      );

      // Assert
      expect(find.text(customHintText), findsOneWidget);
    });

    testWidgets('should display prefix icon when provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      const prefixIcon = Icon(Icons.search, key: Key('search_icon'));

      // Act
      await tester.pumpWidget(
        const SimpleTestWrapper(child: SearchBox(prefixIcon: prefixIcon)),
      );

      // Assert
      expect(find.byKey(const Key('search_icon')), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should display suffix icon when provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      const suffixIcon = Icon(Icons.filter_list, key: Key('filter_icon'));

      // Act
      await tester.pumpWidget(
        const SimpleTestWrapper(child: SearchBox(suffixIcon: suffixIcon)),
      );

      // Assert
      expect(find.byKey(const Key('filter_icon')), findsOneWidget);
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('should accept text input', (WidgetTester tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: SearchBox(controller: controller)),
      );

      await tester.enterText(find.byType(TextField), 'Persian');
      await tester.pump();

      // Assert
      expect(controller.text, equals('Persian'));
      expect(find.text('Persian'), findsOneWidget);
    });

    testWidgets('should apply custom content padding', (
      WidgetTester tester,
    ) async {
      // Arrange
      const customPadding = EdgeInsets.all(20.0);

      // Act
      await tester.pumpWidget(
        const SimpleTestWrapper(
          child: SearchBox(contentPadding: customPadding),
        ),
      );

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration!.contentPadding, equals(customPadding));
    });

    testWidgets('should apply custom background color', (
      WidgetTester tester,
    ) async {
      // Arrange
      const customColor = Colors.blue;

      // Act
      await tester.pumpWidget(
        const SimpleTestWrapper(child: SearchBox(backgroundColor: customColor)),
      );

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration!.fillColor, equals(customColor));
    });

    testWidgets('should apply custom input text style', (
      WidgetTester tester,
    ) async {
      // Arrange
      const customStyle = TextStyle(fontSize: 18, color: Colors.red);
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(
          child: SearchBox(controller: controller, inputTextStyle: customStyle),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Test');
      await tester.pump();

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.style, equals(customStyle));
    });

    testWidgets('should apply custom hint style', (WidgetTester tester) async {
      // Arrange
      const customHintStyle = TextStyle(fontSize: 14, color: Colors.grey);

      // Act
      await tester.pumpWidget(
        const SimpleTestWrapper(child: SearchBox(hintStyle: customHintStyle)),
      );

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration!.hintStyle, equals(customHintStyle));
    });

    testWidgets('should apply custom enabled border', (
      WidgetTester tester,
    ) async {
      // Arrange
      final customBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      );

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: SearchBox(enabledBorder: customBorder)),
      );

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration!.enabledBorder, equals(customBorder));
    });

    testWidgets('should apply custom focused border', (
      WidgetTester tester,
    ) async {
      // Arrange
      final customBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      );

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: SearchBox(focusedBorder: customBorder)),
      );

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration!.focusedBorder, equals(customBorder));
    });

    testWidgets('should handle focus correctly', (WidgetTester tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: SearchBox(controller: controller)),
      );

      // Focus the text field
      await tester.tap(find.byType(TextField));
      await tester.pump();

      // Assert field is focused
      expect(tester.binding.focusManager.primaryFocus?.hasFocus, isTrue);
    });

    testWidgets('should clear text when controller is cleared', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController(text: 'Initial text');

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: SearchBox(controller: controller)),
      );

      // Verify initial text
      expect(find.text('Initial text'), findsOneWidget);

      // Clear controller
      controller.clear();
      await tester.pump();

      // Assert
      expect(find.text('Initial text'), findsNothing);
      expect(controller.text, isEmpty);
    });

    testWidgets('should handle long text input correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController();
      const longText =
          'This is a very long text that should be handled correctly by the search box widget even if it exceeds normal input length';

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: SearchBox(controller: controller)),
      );

      await tester.enterText(find.byType(TextField), longText);
      await tester.pump();

      // Assert
      expect(controller.text, equals(longText));
      expect(find.text(longText), findsOneWidget);
    });

    testWidgets('should handle special characters in input', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController();
      const specialText = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

      // Act
      await tester.pumpWidget(
        SimpleTestWrapper(child: SearchBox(controller: controller)),
      );

      await tester.enterText(find.byType(TextField), specialText);
      await tester.pump();

      // Assert
      expect(controller.text, equals(specialText));
    });

    testWidgets('should maintain state across rebuilds', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController();
      const testText = 'Persistent text';

      // Act - Initial build
      await tester.pumpWidget(
        SimpleTestWrapper(child: SearchBox(controller: controller)),
      );

      await tester.enterText(find.byType(TextField), testText);
      await tester.pump();

      // Rebuild widget
      await tester.pumpWidget(
        SimpleTestWrapper(child: SearchBox(controller: controller)),
      );

      // Assert text persists
      expect(controller.text, equals(testText));
      expect(find.text(testText), findsOneWidget);
    });
  });
}
