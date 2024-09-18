import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safify/constants.dart';
import 'package:safify/dummy.dart';
import 'package:safify/models/token_expired.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> fetchAnalytics() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentUserId = prefs.getString("user_id");
      String? jwtToken = await _storage.read(key: 'jwt');

      if (currentUserId == null || jwtToken == null) {
        throw Exception('User ID or JWT token not found.');
      }

      Uri url = Uri.parse('$IP_URL/analytics/fetchAllAnalytics');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        return jsonResponse;
        // List<UserReport> reportList = jsonResponse
        //     .map((dynamic item) => UserReport.fromJson(item))
        //     .toList();

        // return reportList;
      } else {
        final responseBody = jsonDecode(response.body);
        final status = responseBody['message'];

        if (status.contains('Invalid token.') ||
            status.contains('Access denied')) {
          throw TokenExpiredException('Error: $status');
        } else {
          throw Exception('Error: $status');
        }
      }
    } catch (e) {
      if (e is TokenExpiredException) {
        // Preserve the TokenExpiredException and rethrow it
        throw e;
      } else {
        // Catch-all for other exceptions
        throw Exception('Failed to load Reports');
      }
    }
  }
}
