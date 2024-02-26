import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String BaseUrl = 'http://localhost:8081';

  static Future<http.Response> fetchData(String endpoint) async {
    return http.get( Uri.parse('$BaseUrl/$endpoint') );
  }

  static Future<http.Response> postData(String endpoint, dynamic data) async {
    return http.post(
      Uri.parse('$BaseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
  }
}
