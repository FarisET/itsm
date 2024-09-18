import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safify/constants.dart';

class ActionReportsService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> deleteActionReport(int actionReportId) async {
    final jwtToken = await storage.read(key: 'jwt');
    Uri url =
        Uri.parse('$IP_URL/admin/dashboard/deleteActionReport/$actionReportId');
    try {
      //final response = await http.delete(Uri.parse(apiUrl));
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
        },
      );
      if (response.statusCode == 200) {
        // User report deleted successfully
        print('Action report deleted');
        return true;
      } else {
        // Error deleting user report
        print('Error deleting action report - ${response.body}');
        return false;
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error deleting action report - $error');
      return false;
    }
  }
}
