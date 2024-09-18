import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safify/constants.dart';

class UserReportsService {
  final storage = const FlutterSecureStorage();

  Future<bool> deleteUserReport(String userReportId) async {
    final jwtToken = await storage.read(key: 'jwt');
    Uri url =
        Uri.parse('$IP_URL/admin/dashboard/deleteUserReport/$userReportId');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
        },
      );
      if (response.statusCode == 200) {
        // User report deleted successfully
        print('User report deleted');
        return true;
      } else {
        // Error deleting user report
        print('Error deleting user report - ${response.body}');
        return false;
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Exception: $error');
      return false;
    }
  }
}
