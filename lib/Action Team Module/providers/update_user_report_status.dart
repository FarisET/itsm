import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:safify/constants.dart';

class UserStatusProvider with ChangeNotifier {
  Future<void> updateDeletedReportStatus(String userId, bool status) async {
    try {
      final url = Uri.parse('${IP_URL}/helper/revertPushNotification/$userId');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Failed to update user status');
      }
    } catch (error) {
      rethrow;
    }
  }
}
