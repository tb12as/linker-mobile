import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpHelper {
  String baseUrl = 'https://lnkr.pw/api';

  Future<http.Response> get(String endpoint) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // print('calling : $baseUrl$endpoint');
    final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    _responseValidation(response);

    return response;
  }

  // Will be used soon.
  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // idk if this will work or not:v
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    // _responseValidation(response);

    if (response.statusCode == 401) {
      prefs.remove('token');
    }

    return response;
  }

  void _responseValidation(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'panic: ${response.statusCode} res: ${response.body.toString()}',
      );
    }
  }
}
