import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pet_finder/core/networking/api_error_handler.dart';
import 'package:pet_finder/core/networking/api_error_model.dart';
import 'package:pet_finder/core/networking/api_result.dart';
import 'package:pet_finder/features/home/logic/home_cubit.dart';
import 'package:pet_finder/features/home/logic/home_state.dart' as home_state;

import 'test_helpers/mock_home_repo.dart';
import 'test_helpers/test_data_factory.dart';

void main() {
  group('HomeCubit Unit Tests', () {
    late HomeCubit homeCubit;
    late MockHomeRepo mockHomeRepo;

    setUp(() {
      mockHomeRepo = MockHomeRepo();
      homeCubit = HomeCubit(mockHomeRepo);
    });

    tearDown(() {
      homeCubit.close();
    });

    group('Initial State', () {
      test('should have initial state when created', () {
        expect(homeCubit.state, equals(const home_state.HomeState.initial()));
        expect(homeCubit.breedsList, equals([]));
      });
    });

    group('getBreeds', () {
      test(
        'should emit loading then success when getBreeds succeeds',
        () async {
          // Arrange
          final mockBreeds = TestDataFactory.createBreedsList(count: 3);
          when(
            mockHomeRepo.getBreeds(),
          ).thenAnswer((_) async => ApiResult.success(mockBreeds));

          // Act & Assert
          expectLater(
            homeCubit.stream,
            emitsInOrder([
              isA<home_state.Loading>(),
              isA<home_state.Success>(),
            ]),
          );

          homeCubit.getBreeds();

          await untilCalled(mockHomeRepo.getBreeds());

          // Verify the breeds list is stored
          expect(homeCubit.breedsList, equals(mockBreeds));
          verify(mockHomeRepo.getBreeds()).called(1);
        },
      );

      test(
        'should emit loading then success when getBreeds returns empty list',
        () async {
          // Arrange
          final emptyBreeds = TestDataFactory.createEmptyBreedsList();
          when(
            mockHomeRepo.getBreeds(),
          ).thenAnswer((_) async => ApiResult.success(emptyBreeds));

          // Act & Assert
          expectLater(
            homeCubit.stream,
            emitsInOrder([
              isA<home_state.Loading>(),
              isA<home_state.Success>(),
            ]),
          );

          homeCubit.getBreeds();

          await untilCalled(mockHomeRepo.getBreeds());

          expect(homeCubit.breedsList, equals(emptyBreeds));
          expect(homeCubit.breedsList!.length, equals(0));
          verify(mockHomeRepo.getBreeds()).called(1);
        },
      );

      test('should emit loading then error when getBreeds fails', () async {
        // Arrange
        final errorHandler = ErrorHandler.handle(
          Exception('Network error occurred'),
        );
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.failure(errorHandler));

        // Act & Assert
        expectLater(
          homeCubit.stream,
          emitsInOrder([isA<home_state.Loading>(), isA<home_state.Error>()]),
        );

        homeCubit.getBreeds();

        await untilCalled(mockHomeRepo.getBreeds());

        verify(mockHomeRepo.getBreeds()).called(1);
      });

      test(
        'should emit loading then error with default message when error message is null',
        () async {
          // Arrange
          final apiErrorModel = ApiErrorModel(code: 500, message: null);
          final errorHandler = ErrorHandler.handle(Exception());
          errorHandler.apiErrorModel = apiErrorModel;

          when(
            mockHomeRepo.getBreeds(),
          ).thenAnswer((_) async => ApiResult.failure(errorHandler));

          // Act & Assert
          expectLater(
            homeCubit.stream,
            emitsInOrder([isA<home_state.Loading>(), isA<home_state.Error>()]),
          );

          homeCubit.getBreeds();

          await untilCalled(mockHomeRepo.getBreeds());

          verify(mockHomeRepo.getBreeds()).called(1);
        },
      );

      test('should handle multiple consecutive calls correctly', () async {
        // Arrange
        final mockBreeds1 = TestDataFactory.createBreedsList(count: 2);
        final mockBreeds2 = TestDataFactory.createBreedsList(count: 4);

        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(mockBreeds1));

        // Act - First call
        homeCubit.getBreeds();
        await untilCalled(mockHomeRepo.getBreeds());

        // Assert first call
        expect(homeCubit.breedsList, equals(mockBreeds1));

        // Setup for second call
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(mockBreeds2));

        // Act - Second call
        homeCubit.getBreeds();
        await untilCalled(mockHomeRepo.getBreeds());

        // Assert second call overwrites first
        expect(homeCubit.breedsList, equals(mockBreeds2));
        expect(homeCubit.breedsList!.length, equals(4));

        verify(mockHomeRepo.getBreeds()).called(2);
      });

      test('should handle success after previous error', () async {
        // Arrange - First call fails
        final errorHandler = ErrorHandler.handle(Exception('Network error'));
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.failure(errorHandler));

        // Act - First call (error)
        homeCubit.getBreeds();
        await untilCalled(mockHomeRepo.getBreeds());

        // Assert error state
        expect(homeCubit.state, isA<home_state.Error>());

        // Arrange - Second call succeeds
        final mockBreeds = TestDataFactory.createBreedsList(count: 2);
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(mockBreeds));

        // Act - Second call (success)
        homeCubit.getBreeds();
        await untilCalled(mockHomeRepo.getBreeds());

        // Assert success state
        expect(homeCubit.state, isA<home_state.Success>());
        expect(homeCubit.breedsList, equals(mockBreeds));

        verify(mockHomeRepo.getBreeds()).called(2);
      });

      test('should preserve breedsList when error occurs', () async {
        // Arrange - First successful call
        final initialBreeds = TestDataFactory.createBreedsList(count: 3);
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(initialBreeds));

        // Act - First call
        homeCubit.getBreeds();
        await untilCalled(mockHomeRepo.getBreeds());

        expect(homeCubit.breedsList, equals(initialBreeds));

        // Arrange - Second call fails
        final errorHandler = ErrorHandler.handle(Exception('Network error'));
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.failure(errorHandler));

        // Act - Second call (error)
        homeCubit.getBreeds();
        await untilCalled(mockHomeRepo.getBreeds());

        // Assert breedsList is preserved even after error
        expect(homeCubit.breedsList, equals(initialBreeds));
        expect(homeCubit.state, isA<home_state.Error>());

        verify(mockHomeRepo.getBreeds()).called(2);
      });
    });

    group('State Management', () {
      test('should maintain state consistency', () async {
        // Test initial state
        expect(homeCubit.state.runtimeType.toString(), contains('Initial'));

        // Setup success response
        final mockBreeds = TestDataFactory.createBreedsList(count: 2);
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(mockBreeds));

        // Call getBreeds and wait
        homeCubit.getBreeds();
        await untilCalled(mockHomeRepo.getBreeds());

        // Verify final state using when method
        homeCubit.state.when(
          initial: () => fail('Should not be in initial state'),
          loading: () => fail('Should not be in loading state'),
          success: (data) => expect(data, equals(mockBreeds)),
          error: (error) => fail('Should not be in error state'),
        );
      });

      test('should handle state transitions correctly', () async {
        final states = <home_state.HomeState>[];
        homeCubit.stream.listen(states.add);

        // Setup and call
        final mockBreeds = TestDataFactory.createBreedsList(count: 1);
        when(
          mockHomeRepo.getBreeds(),
        ).thenAnswer((_) async => ApiResult.success(mockBreeds));

        homeCubit.getBreeds();
        await untilCalled(mockHomeRepo.getBreeds());

        // Allow time for state emissions
        await Future.delayed(const Duration(milliseconds: 10));

        expect(states.length, equals(2));
        expect(states[0].runtimeType.toString(), contains('Loading'));
        expect(states[1].runtimeType.toString(), contains('Success'));
      });
    });
  });
}
