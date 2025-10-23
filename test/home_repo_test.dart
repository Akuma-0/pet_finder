import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pet_finder/core/networking/api_error_handler.dart';
import 'package:pet_finder/core/networking/api_result.dart';
import 'package:pet_finder/core/networking/api_services.dart';
import 'package:pet_finder/features/home/data/models/breeds_response_model.dart';
import 'package:pet_finder/features/home/data/repos/home_repo.dart';

import 'test_helpers/test_data_factory.dart';

// Mock classes
class MockApiService extends Mock implements ApiService {
  @override
  Future<List<Breed>> getBreeds() => super.noSuchMethod(
    Invocation.method(#getBreeds, []),
    returnValue: Future.value(<Breed>[]),
  );
}

void main() {
  group('HomeRepo Unit Tests', () {
    late HomeRepo homeRepo;
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
      homeRepo = HomeRepo(mockApiService);
    });

    group('getBreeds', () {
      test('should return success when API call succeeds', () async {
        // Arrange
        final mockBreeds = TestDataFactory.createBreedsList(count: 3);
        when(mockApiService.getBreeds()).thenAnswer((_) async => mockBreeds);

        // Act
        final result = await homeRepo.getBreeds();

        // Assert
        expect(result, isA<Success>());
        result.when(
          success: (breeds) {
            expect(breeds, equals(mockBreeds));
            expect(breeds.length, equals(3));
          },
          failure: (error) => fail('Should not return failure'),
        );

        verify(mockApiService.getBreeds()).called(1);
      });

      test(
        'should return success with empty list when API returns empty list',
        () async {
          // Arrange
          final emptyBreeds = TestDataFactory.createEmptyBreedsList();
          when(mockApiService.getBreeds()).thenAnswer((_) async => emptyBreeds);

          // Act
          final result = await homeRepo.getBreeds();

          // Assert
          expect(result, isA<Success>());
          result.when(
            success: (breeds) {
              expect(breeds, equals(emptyBreeds));
              expect(breeds.length, equals(0));
            },
            failure: (error) => fail('Should not return failure'),
          );

          verify(mockApiService.getBreeds()).called(1);
        },
      );

      test('should return failure when API call throws DioException', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/breeds'),
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        );
        when(mockApiService.getBreeds()).thenThrow(dioException);

        // Act
        final result = await homeRepo.getBreeds();

        // Assert
        expect(result, isA<Failure>());
        result.when(
          success: (breeds) => fail('Should not return success'),
          failure: (error) {
            expect(error, isA<ErrorHandler>());
            expect(error.apiErrorModel.code, equals(-1)); // CONNECT_TIMEOUT
          },
        );

        verify(mockApiService.getBreeds()).called(1);
      });

      test(
        'should return failure when API call throws general Exception',
        () async {
          // Arrange
          when(
            mockApiService.getBreeds(),
          ).thenThrow(Exception('General error'));

          // Act
          final result = await homeRepo.getBreeds();

          // Assert
          expect(result, isA<Failure>());
          result.when(
            success: (breeds) => fail('Should not return success'),
            failure: (error) {
              expect(error, isA<ErrorHandler>());
              expect(error.apiErrorModel.code, equals(-7)); // DEFAULT error
            },
          );

          verify(mockApiService.getBreeds()).called(1);
        },
      );

      test(
        'should return failure when API call throws HTTP 404 error',
        () async {
          // Arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/breeds'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/breeds'),
              statusCode: 404,
              data: {'message': 'Not found'},
            ),
          );
          when(mockApiService.getBreeds()).thenThrow(dioException);

          // Act
          final result = await homeRepo.getBreeds();

          // Assert
          expect(result, isA<Failure>());
          result.when(
            success: (breeds) => fail('Should not return success'),
            failure: (error) {
              expect(error, isA<ErrorHandler>());
              // Should have some error information
              expect(error.apiErrorModel, isNotNull);
            },
          );

          verify(mockApiService.getBreeds()).called(1);
        },
      );

      test(
        'should return failure when API call throws HTTP 500 error',
        () async {
          // Arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/breeds'),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: '/breeds'),
              statusCode: 500,
              data: {'message': 'Internal server error'},
            ),
          );
          when(mockApiService.getBreeds()).thenThrow(dioException);

          // Act
          final result = await homeRepo.getBreeds();

          // Assert
          expect(result, isA<Failure>());
          result.when(
            success: (breeds) => fail('Should not return success'),
            failure: (error) {
              expect(error, isA<ErrorHandler>());
              expect(error.apiErrorModel, isNotNull);
            },
          );

          verify(mockApiService.getBreeds()).called(1);
        },
      );

      test('should handle network timeout correctly', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/breeds'),
          type: DioExceptionType.receiveTimeout,
          message: 'Receive timeout',
        );
        when(mockApiService.getBreeds()).thenThrow(dioException);

        // Act
        final result = await homeRepo.getBreeds();

        // Assert
        expect(result, isA<Failure>());
        result.when(
          success: (breeds) => fail('Should not return success'),
          failure: (error) {
            expect(error, isA<ErrorHandler>());
            expect(error.apiErrorModel.code, equals(-3)); // RECEIVE_TIMEOUT
          },
        );

        verify(mockApiService.getBreeds()).called(1);
      });

      test('should handle cancelled request correctly', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/breeds'),
          type: DioExceptionType.cancel,
          message: 'Request cancelled',
        );
        when(mockApiService.getBreeds()).thenThrow(dioException);

        // Act
        final result = await homeRepo.getBreeds();

        // Assert
        expect(result, isA<Failure>());
        result.when(
          success: (breeds) => fail('Should not return success'),
          failure: (error) {
            expect(error, isA<ErrorHandler>());
            expect(error.apiErrorModel.code, equals(-2)); // CANCEL
          },
        );

        verify(mockApiService.getBreeds()).called(1);
      });

      test('should handle multiple concurrent calls correctly', () async {
        // Arrange
        final mockBreeds1 = TestDataFactory.createBreedsList(count: 2);
        final mockBreeds2 = TestDataFactory.createBreedsList(count: 4);

        when(mockApiService.getBreeds()).thenAnswer((_) async => mockBreeds1);

        // Act - First call
        final result1 = await homeRepo.getBreeds();

        // Setup for second call
        when(mockApiService.getBreeds()).thenAnswer((_) async => mockBreeds2);

        // Act - Second call
        final result2 = await homeRepo.getBreeds();

        // Assert both calls succeed independently
        expect(result1, isA<Success>());
        expect(result2, isA<Success>());

        result1.when(
          success: (breeds) => expect(breeds.length, equals(2)),
          failure: (error) => fail('First call should succeed'),
        );

        result2.when(
          success: (breeds) => expect(breeds.length, equals(4)),
          failure: (error) => fail('Second call should succeed'),
        );

        verify(mockApiService.getBreeds()).called(2);
      });
    });

    group('Error Handling Edge Cases', () {
      test('should handle null response data gracefully', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/breeds'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/breeds'),
            statusCode: 500,
            data: null,
          ),
        );
        when(mockApiService.getBreeds()).thenThrow(dioException);

        // Act
        final result = await homeRepo.getBreeds();

        // Assert
        expect(result, isA<Failure>());
        result.when(
          success: (breeds) => fail('Should not return success'),
          failure: (error) {
            expect(error, isA<ErrorHandler>());
            // Should fall back to default error handling
            expect(error.apiErrorModel.code, equals(-7)); // DEFAULT
          },
        );

        verify(mockApiService.getBreeds()).called(1);
      });

      test('should handle response without status code gracefully', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/breeds'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/breeds'),
            statusCode: null,
            data: {'message': 'Error without status code'},
          ),
        );
        when(mockApiService.getBreeds()).thenThrow(dioException);

        // Act
        final result = await homeRepo.getBreeds();

        // Assert
        expect(result, isA<Failure>());
        result.when(
          success: (breeds) => fail('Should not return success'),
          failure: (error) {
            expect(error, isA<ErrorHandler>());
            expect(error.apiErrorModel.code, equals(-7)); // DEFAULT
          },
        );

        verify(mockApiService.getBreeds()).called(1);
      });
    });
  });
}
