import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safify/constants.dart';
import 'package:safify/models/token_expired.dart';
import 'package:safify/widgets/notification_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifTestService {
  static const storage = FlutterSecureStorage();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Fetches current user's user-reports from the API
  static void testNotif() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentUserId = prefs.getString("user_id");
      String? jwtToken = await storage.read(key: 'jwt');

      // debugPrint("Current User ID: $currentUserId");

      if (currentUserId == null || jwtToken == null) {
        throw Exception('User ID or JWT token not found.');
      }

      Uri url = Uri.parse('$IP_URL/helper/sendDummyNotification');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "user_id": currentUserId,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("Test Notification response: ${response.body}");
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
