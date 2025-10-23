import 'package:flutter_test/flutter_test.dart';
import 'package:pet_finder/core/networking/api_error_model.dart';

void main() {
  group('ApiErrorModel Tests', () {
    test('should create ApiErrorModel from JSON response', () {
      // Arrange
      final jsonResponse = {'message': 'Invalid request', 'code': 400};

      // Act
      final result = ApiErrorModel.fromJson(jsonResponse);

      // Assert
      expect(result.message, equals('Invalid request'));
      expect(result.code, equals(400));
    });

    test('should create ApiErrorModel from plain string response', () {
      // Arrange
      const stringResponse =
          "AUTHENTICATION_ERROR - you need to send your API Key as the 'x-api-key' header";
      const statusCode = 401;

      // Act
      final result = ApiErrorModel.fromString(
        stringResponse,
        statusCode: statusCode,
      );

      // Assert
      expect(result.message, equals(stringResponse));
      expect(result.code, equals(statusCode));
    });

    test('should create ApiErrorModel from dynamic string response', () {
      // Arrange
      const stringResponse =
          "AUTHENTICATION_ERROR - you need to send your API Key as the 'x-api-key' header";
      const statusCode = 401;

      // Act
      final result = ApiErrorModel.fromResponse(
        stringResponse,
        statusCode: statusCode,
      );

      // Assert
      expect(result.message, equals(stringResponse));
      expect(result.code, equals(statusCode));
    });

    test('should create ApiErrorModel from dynamic JSON response', () {
      // Arrange
      final jsonResponse = {'message': 'Bad Request', 'code': 400};

      // Act
      final result = ApiErrorModel.fromResponse(jsonResponse, statusCode: 400);

      // Assert
      expect(result.message, equals('Bad Request'));
      expect(result.code, equals(400));
    });

    test('should handle unknown response types', () {
      // Arrange
      const unknownResponse = 12345;
      const statusCode = 500;

      // Act
      final result = ApiErrorModel.fromResponse(
        unknownResponse,
        statusCode: statusCode,
      );

      // Assert
      expect(result.message, equals('12345'));
      expect(result.code, equals(statusCode));
    });
  });
}
