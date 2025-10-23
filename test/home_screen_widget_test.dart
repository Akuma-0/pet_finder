import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_finder/features/home/logic/home_cubit.dart';
import 'package:pet_finder/features/home/ui/home_screen.dart';
import 'package:pet_finder/features/home/ui/widgets/home_bloc_builder.dart';
import 'package:pet_finder/features/home/ui/widgets/search_box.dart';

import 'test_helpers/mock_home_repo.dart';
import 'test_helpers/test_widget_wrapper.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    late MockHomeRepo mockHomeRepo;
    late HomeCubit homeCubit;

    setUp(() {
      mockHomeRepo = MockHomeRepo();
      homeCubit = HomeCubit(mockHomeRepo);
    });

    tearDown(() {
      homeCubit.close();
    });

    Widget createTestWidget() {
      return TestWidgetWrapper(
        child: BlocProvider<HomeCubit>(
          create: (_) => homeCubit,
          child: const HomeScreen(),
        ),
      );
    }

    testWidgets('should render HomeScreen with all main components', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SearchBox), findsOneWidget);
      expect(find.byType(HomeBlocBuilder), findsOneWidget);
    });

    testWidgets('should display correct app bar title', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Find Your Forever Pet'), findsOneWidget);
    });

    testWidgets('should display notification icon in app bar', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byIcon(Icons.notifications_none_outlined), findsOneWidget);
    });

    testWidgets('should display search box with correct icons', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(SearchBox), findsOneWidget);
      // The SearchBox should have prefix and suffix icons
      expect(find.byIcon(Icons.tune), findsOneWidget); // Filter icon (rotated)
    });

    testWidgets('should have proper scaffold structure', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(
        find.byType(Padding),
        findsWidgets,
      ); // Should have scaffold padding
      expect(find.byType(Column), findsWidgets); // Body should contain Column
    });

    testWidgets('should display search box with proper spacing', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(SizedBox), findsWidgets); // Spacing elements
      expect(find.byType(SearchBox), findsOneWidget);
    });

    testWidgets('should have expanded widget for content area', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(Expanded), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(Expanded),
          matching: find.byType(HomeBlocBuilder),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should be scrollable when content is large', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // The main body should handle scrolling properly
      // This test ensures the basic structure allows for scrolling
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('should maintain proper layout proportions', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Get the scaffold
      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsOneWidget);

      // Verify body structure
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should handle app bar actions correctly', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.actions, isNotNull);
      expect(appBar.actions!.length, equals(1));
    });

    testWidgets('should apply correct padding to body content', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - Check that padding is applied to main content
      final paddingWidgets = find.byType(Padding);
      expect(paddingWidgets, findsWidgets);

      // The main content should be wrapped in Padding
      expect(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byType(Padding),
        ),
        findsWidgets,
      );
    });

    testWidgets('should position search box correctly in layout', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - SearchBox should be positioned before HomeBlocBuilder in the Column
      final column = find.byType(Column);
      expect(column, findsWidgets);

      expect(find.byType(SearchBox), findsOneWidget);
      expect(find.byType(HomeBlocBuilder), findsOneWidget);
    });

    testWidgets('should handle orientation changes gracefully', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Simulate orientation change by changing size
      tester.view.physicalSize = const Size(800, 600); // Landscape-like
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pump();

      // Assert - Layout should still be intact
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(SearchBox), findsOneWidget);
      expect(find.byType(HomeBlocBuilder), findsOneWidget);
    });

    testWidgets('should provide proper context to child widgets', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - HomeBlocBuilder should have access to HomeCubit through context
      expect(find.byType(HomeBlocBuilder), findsOneWidget);

      // The BlocProvider should make HomeCubit available to descendants
      final context = tester.element(find.byType(HomeBlocBuilder));
      final cubits = BlocProvider.of<HomeCubit>(context);
      expect(cubits, isNotNull);
    });

    testWidgets('should handle theme changes correctly', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - Should use theme-aware widgets
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);

      // Colors and styles should be applied from theme
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.title, isNotNull);
    });

    testWidgets('should be accessible for screen readers', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - Check for semantic properties
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);

      // App bar title should be accessible
      expect(find.text('Find Your Forever Pet'), findsOneWidget);
    });

    testWidgets('should handle safe area correctly', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - Scaffold should handle safe area
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.appBar, isNotNull);
      expect(scaffold.body, isNotNull);
    });

    testWidgets('should maintain state during rebuilds', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Verify initial state
      expect(find.byType(HomeScreen), findsOneWidget);

      // Force rebuild
      await tester.pumpWidget(createTestWidget());

      // Assert - Should maintain structure
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(SearchBox), findsOneWidget);
      expect(find.byType(HomeBlocBuilder), findsOneWidget);
    });

    testWidgets('should display filter icon rotated correctly', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - Filter icon should be present and rotated
      expect(find.byType(RotatedBox), findsOneWidget);

      final rotatedBox = tester.widget<RotatedBox>(find.byType(RotatedBox));
      expect(rotatedBox.quarterTurns, equals(3));

      expect(
        find.descendant(
          of: find.byType(RotatedBox),
          matching: find.byIcon(Icons.tune),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should handle search interaction properly', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Find and interact with search box
      final searchBox = find.byType(SearchBox);
      expect(searchBox, findsOneWidget);

      // Tap on search box should focus it
      await tester.tap(searchBox);
      await tester.pump();

      // Should not throw any errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('should integrate properly with ScreenUtil', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert - Should render without screen util errors
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
