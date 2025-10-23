import 'package:json_annotation/json_annotation.dart';

part 'api_error_model.g.dart';

@JsonSerializable()
class ApiErrorModel {
  final String? message;
  final int? code;

  ApiErrorModel({required this.message, this.code});

  /// Factory constructor for JSON responses
  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  /// Factory constructor for plain string responses
  factory ApiErrorModel.fromString(String errorMessage, {int? statusCode}) {
    return ApiErrorModel(message: errorMessage, code: statusCode);
  }

  /// Factory constructor for dynamic responses (handles both JSON and String)
  factory ApiErrorModel.fromResponse(dynamic response, {int? statusCode}) {
    if (response is String) {
      return ApiErrorModel.fromString(response, statusCode: statusCode);
    } else if (response is Map<String, dynamic>) {
      return ApiErrorModel.fromJson(response);
    } else {
      // Fallback for any other type
      return ApiErrorModel.fromString(
        response?.toString() ?? 'Unknown error',
        statusCode: statusCode,
      );
    }
  }

  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);
}

/// This model can handle both JSON and plain string error responses from the API.
/// Examples:
/// 
/// For JSON response: {"message": "Invalid request", "code": 400}
/// Usage: ApiErrorModel.fromJson(jsonResponse)
/// 
/// For plain string response: "AUTHENTICATION_ERROR - you need to send your API Key as the 'x-api-key' header"
/// Usage: ApiErrorModel.fromString(stringResponse, statusCode: 401)
/// 
/// For dynamic response (auto-detects type):
/// Usage: ApiErrorModel.fromResponse(response, statusCode: statusCode)
