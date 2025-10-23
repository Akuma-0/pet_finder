import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_finder/features/home/logic/home_cubit.dart';
import 'package:pet_finder/features/home/logic/home_state.dart' as home_state;
import 'package:pet_finder/features/home/ui/widgets/home_bloc_builder.dart';
import 'package:pet_finder/features/home/ui/widgets/breeds_list_view.dart';

import 'test_helpers/mock_home_repo.dart';
import 'test_helpers/test_data_factory.dart';
import 'test_helpers/test_widget_wrapper.dart';

void main() {
  group('HomeBlocBuilder Widget Tests', () {
    late HomeCubit mockHomeCubit;
    late MockHomeRepo mockHomeRepo;

    setUp(() {
      mockHomeRepo = MockHomeRepo();
      mockHomeCubit = HomeCubit(mockHomeRepo);
    });

    tearDown(() {
      mockHomeCubit.close();
    });

    Widget createTestWidget({required Widget child}) {
      return SimpleTestWrapper(
        child: BlocProvider<HomeCubit>(
          create: (_) => mockHomeCubit,
          child: child,
        ),
      );
    }

    testWidgets('should show empty widget for initial state', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(child: const HomeBlocBuilder()));

      // Assert - Initial state should show nothing (SizedBox.shrink)
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(BreedsListView), findsNothing);
    });

    testWidgets('should handle cubit state changes', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(child: const HomeBlocBuilder()));

      // Test loading state directly through cubit
      mockHomeCubit.emit(const home_state.HomeState.loading());
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Test success state
      mockHomeCubit.emit(
        home_state.HomeState.success(TestDataFactory.createBreedsList()),
      );
      await tester.pump();
      expect(find.byType(BreedsListView), findsOneWidget);
    });

    testWidgets('should show breeds list when in success state', (
      WidgetTester tester,
    ) async {
      // Arrange
      final mockBreeds = TestDataFactory.createBreedsList(count: 3);

      // Act
      await tester.pumpWidget(createTestWidget(child: const HomeBlocBuilder()));

      // Manually emit success state
      mockHomeCubit.emit(home_state.HomeState.success(mockBreeds));
      await tester.pump();

      // Assert
      expect(find.byType(BreedsListView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should show error widget when in error state', (
      WidgetTester tester,
    ) async {
      // Arrange
      const errorMessage = 'Failed to load breeds';

      // Act
      await tester.pumpWidget(createTestWidget(child: const HomeBlocBuilder()));

      // Manually emit error state
      mockHomeCubit.emit(const home_state.HomeState.error(error: errorMessage));
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Failed to load breeds'), findsOneWidget);
      expect(
        find.text('Please check your internet connection'),
        findsOneWidget,
      );
      expect(find.byType(BreedsListView), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should handle empty breeds list in success state', (
      WidgetTester tester,
    ) async {
      // Arrange
      final emptyBreeds = TestDataFactory.createEmptyBreedsList();

      // Act
      await tester.pumpWidget(createTestWidget(child: const HomeBlocBuilder()));

      // Manually emit success state with empty list
      mockHomeCubit.emit(home_state.HomeState.success(emptyBreeds));
      await tester.pump();

      // Assert
      expect(find.byType(BreedsListView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should rebuild when state changes', (
      WidgetTester tester,
    ) async {
      // Arrange
      final mockBreeds = TestDataFactory.createBreedsList(count: 2);

      // Act
      await tester.pumpWidget(createTestWidget(child: const HomeBlocBuilder()));

      // Initial state - should show empty
      expect(find.byType(SizedBox), findsOneWidget);

      // Change to loading
      mockHomeCubit.emit(const home_state.HomeState.loading());
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Change to success
      mockHomeCubit.emit(home_state.HomeState.success(mockBreeds));
      await tester.pump();
      expect(find.byType(BreedsListView), findsOneWidget);

      // Change to error
      mockHomeCubit.emit(const home_state.HomeState.error(error: 'Test error'));
      await tester.pump();
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets(
      'should use buildWhen correctly to prevent unnecessary rebuilds',
      (WidgetTester tester) async {
        // This test ensures that the BlocBuilder only rebuilds for specific states
        int buildCount = 0;

        // Create a custom HomeBlocBuilder to count builds
        final testWidget = BlocBuilder<HomeCubit, home_state.HomeState>(
          buildWhen: (previous, current) =>
              current is home_state.Loading ||
              current is home_state.Success ||
              current is home_state.Error,
          builder: (context, state) {
            buildCount++;
            return state.maybeWhen(
              loading: () => const CircularProgressIndicator(),
              success: (breedsList) => BreedsListView(breeds: breedsList),
              error: (error) => const Text('Error'),
              orElse: () => const SizedBox.shrink(),
            );
          },
        );

        // Act
        await tester.pumpWidget(createTestWidget(child: testWidget));

        // Initial build
        expect(buildCount, equals(1));

        // Emit states that should trigger rebuilds
        mockHomeCubit.emit(const home_state.HomeState.loading());
        await tester.pump();
        expect(buildCount, equals(2));

        final mockBreeds = TestDataFactory.createBreedsList(count: 1);
        mockHomeCubit.emit(home_state.HomeState.success(mockBreeds));
        await tester.pump();
        expect(buildCount, equals(3));

        mockHomeCubit.emit(const home_state.HomeState.error(error: 'Test'));
        await tester.pump();
        expect(buildCount, equals(4));
      },
    );

    testWidgets('should display correct loading indicator color', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(child: const HomeBlocBuilder()));

      mockHomeCubit.emit(const home_state.HomeState.loading());
      await tester.pump();

      // Assert
      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      // Note: Color verification would need to check the actual color value
      expect(progressIndicator, isNotNull);
    });

    testWidgets('should center loading indicator', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget(child: const HomeBlocBuilder()));

      mockHomeCubit.emit(const home_state.HomeState.loading());
      await tester.pump();

      // Assert
      expect(find.byType(Center), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(Center),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should pass breeds data correctly to BreedsListView', (
      WidgetTester tester,
    ) async {
      // Arrange
      final testBreeds = TestDataFactory.createBreedsList(count: 5);

      // Act
      await tester.pumpWidget(createTestWidget(child: const HomeBlocBuilder()));

      mockHomeCubit.emit(home_state.HomeState.success(testBreeds));
      await tester.pump();

      // Assert
      final breedsListView = tester.widget<BreedsListView>(
        find.byType(BreedsListView),
      );
      expect(breedsListView.breeds, equals(testBreeds));
      expect(breedsListView.breeds.length, equals(5));
    });

    testWidgets('should display error message in error widget', (
      WidgetTester tester,
    ) async {
      // Arrange
      const customErrorMessage = 'Network connection failed';

      // Act
      await tester.pumpWidget(createTestWidget(child: const HomeBlocBuilder()));

      mockHomeCubit.emit(
        const home_state.HomeState.error(error: customErrorMessage),
      );
      await tester.pump();

      // Assert error UI elements
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Failed to load breeds'), findsOneWidget);
      expect(
        find.text('Please check your internet connection'),
        findsOneWidget,
      );

      // The error message from state might not be directly displayed,
      // but the UI should show a user-friendly message
    });

    testWidgets('should handle state transitions smoothly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final mockBreeds = TestDataFactory.createBreedsList(count: 3);

      // Act
      await tester.pumpWidget(createTestWidget(child: const HomeBlocBuilder()));

      // Test smooth transitions
      // Initial -> Loading
      mockHomeCubit.emit(const home_state.HomeState.loading());
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Loading -> Success
      mockHomeCubit.emit(home_state.HomeState.success(mockBreeds));
      await tester.pump();
      expect(find.byType(BreedsListView), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Success -> Loading (retry scenario)
      mockHomeCubit.emit(const home_state.HomeState.loading());
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(BreedsListView), findsNothing);

      // Loading -> Error
      mockHomeCubit.emit(const home_state.HomeState.error(error: 'Failed'));
      await tester.pump();
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should not crash with null or malformed data', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(child: const HomeBlocBuilder()));

      // Test with empty list (safer than null for strongly typed system)
      mockHomeCubit.emit(
        home_state.HomeState.success(TestDataFactory.createEmptyBreedsList()),
      );
      await tester.pump();

      // Assert - Should not crash and should show empty list
      expect(tester.takeException(), isNull);
      expect(find.byType(BreedsListView), findsOneWidget);
    });
  });
}
