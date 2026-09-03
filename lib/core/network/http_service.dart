import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../error/exceptions.dart';
import 'token_manager.dart';

class HttpService {
  final http.Client client;
  final String baseUrl;
  final TokenManager tokenManager;

  HttpService({
    required this.client, 
    required this.baseUrl, 
    required this.tokenManager,
  });

  Map<String, String> _getHeaders(Map<String, String>? extraHeaders) {
    final headers = {
      'Content-Type': 'application/json',
      if (extraHeaders != null) ...extraHeaders,
    };

    final token = tokenManager.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<dynamic> post(String path, {Map<String, String>? headers, dynamic body}) async {
    final url = Uri.parse("$baseUrl$path");
    final requestHeaders = _getHeaders(headers);
    final requestBody = body != null ? jsonEncode(body) : null;

    _logRequest("POST", url, requestHeaders, requestBody);

    final response = await client.post(
      url,
      headers: requestHeaders,
      body: requestBody,
    );

    return _handleResponse(response);
  }

  Future<dynamic> get(String path, {Map<String, String>? headers}) async {
    final url = Uri.parse("$baseUrl$path");
    final requestHeaders = _getHeaders(headers);
    _logRequest("GET", url, requestHeaders, null);

    final response = await client.get(
      url,
      headers: requestHeaders,
    );

    return _handleResponse(response);
  }

  Future<dynamic> patch(String path, {Map<String, String>? headers, dynamic body}) async {
    final url = Uri.parse("$baseUrl$path");
    final requestHeaders = _getHeaders(headers);
    final requestBody = body != null ? jsonEncode(body) : null;

    _logRequest("PATCH", url, requestHeaders, requestBody);

    final response = await client.patch(
      url,
      headers: requestHeaders,
      body: requestBody,
    );

    return _handleResponse(response);
  }

  void _logRequest(String method, Uri url, Map<String, String>? headers, String? body) {
    if (kDebugMode) {
      print("--> $method $url");
      if (headers != null) print("Headers: $headers");
      if (body != null) print("Body: $body");
      print("--> END $method");
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (kDebugMode) {
      print("<-- ${response.statusCode} ${response.request?.method} ${response.request?.url}");
      print("Response Body: ${response.body}");
      print("<-- END HTTP");
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else if (response.statusCode == 422) {
      final data = jsonDecode(response.body);
      throw ServerException(data['detail']?[0]?['msg'] ?? 'Validation Error');
    } else {
      try {
        final data = jsonDecode(response.body);
        throw ServerException(data['message'] ?? 'Server Error: ${response.statusCode}');
      } catch (_) {
        throw ServerException('Failed to connect to server. Status: ${response.statusCode}');
      }
    }
  }
}
