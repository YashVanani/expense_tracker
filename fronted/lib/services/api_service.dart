import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'token_service.dart';

class ApiService {
  // Base URL - Update this with your URL
  // Examples:
  // - Local development: 'http://localhost:3000/api'
  // - Android emulator: 'http://10.0.2.2:3000/api'
  // - iOS simulator: 'http://localhost:3000/api'
  // - Physical device: 'http://YOUR_COMPUTER_IP:3000/api'
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  final TokenService _tokenService = Get.find<TokenService>();

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, String>> get _authHeaders async {
    final token = await _tokenService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = false,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      String url = '$baseUrl$endpoint';

      if (queryParameters != null && queryParameters.isNotEmpty) {
        final uri = Uri.parse(url);
        url = uri.replace(queryParameters: queryParameters).toString();
      }

      final headers = requiresAuth ? await _authHeaders : _headers;

      final response = await http.get(Uri.parse(url), headers: headers);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Network error: ${e.toString()}',
        data: null,
      );
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final headers = requiresAuth ? await _authHeaders : _headers;

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Network error: ${e.toString()}',
        data: null,
      );
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final headers = requiresAuth ? await _authHeaders : _headers;

      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Network error: ${e.toString()}',
        data: null,
      );
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    bool requiresAuth = true,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final headers = requiresAuth ? await _authHeaders : _headers;

      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Network error: ${e.toString()}',
        data: null,
      );
    }
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      final dynamic jsonResponse = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        T? data;

        if (fromJson != null) {
          if (jsonResponse is Map<String, dynamic> &&
              jsonResponse['data'] != null) {
            if (jsonResponse['data'] is List) {
              data =
                  jsonResponse['data']
                          .map<T>(
                            (item) => fromJson(item as Map<String, dynamic>),
                          )
                          .toList()
                      as T;
            } else {
              data = fromJson(jsonResponse['data'] as Map<String, dynamic>);
            }
          } else if (jsonResponse is Map<String, dynamic>) {
            data = fromJson(jsonResponse);
          }
        } else {
          if (jsonResponse is Map<String, dynamic> &&
              jsonResponse['data'] != null) {
            data = jsonResponse['data'] as T?;
          } else {
            data = jsonResponse as T?;
          }
        }

        final message = jsonResponse is Map<String, dynamic>
            ? (jsonResponse['message'] ?? 'Success')
            : 'Success';

        return ApiResponse<T>(
          success: true,
          message: message,
          data: data,
          statusCode: response.statusCode,
        );
      } else {
        final message = jsonResponse is Map<String, dynamic>
            ? (jsonResponse['message'] ??
                  jsonResponse['error'] ??
                  'Request failed')
            : 'Request failed';

        return ApiResponse<T>(
          success: false,
          message: message,
          data: null,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse<T>(
          success: true,
          message: 'Success',
          data: null,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse<T>(
          success: false,
          message: 'Failed to parse response: ${e.toString()}',
          data: null,
          statusCode: response.statusCode,
        );
      }
    }
  }
}

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: fromJson != null && json['data'] != null
          ? fromJson(json['data'] as Map<String, dynamic>)
          : json['data'] as T?,
      statusCode: json['statusCode'],
    );
  }
}
