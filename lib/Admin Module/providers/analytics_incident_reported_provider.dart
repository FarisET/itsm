import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:safify/repositories/analytics_repository.dart';
import '../../constants.dart';

class CountIncidentsReportedProvider extends ChangeNotifier {
  String? _totalIncidentsReported;
  bool loading = false;
  String? jwtToken;
  final storage = const FlutterSecureStorage();
  final AnalyticsRepository _analyticsRepository = AnalyticsRepository();

  String? get totalIncidentsReported => _totalIncidentsReported;

  getCountReportedPostData() async {
    loading = true;
    // _totalIncidentsReported = await fetchIncidentsReported();

    final val = await _analyticsRepository.fetchTotalIncidentsReportedFromDb();
    _totalIncidentsReported = val != null ? val.toString() : "n/a";
    loading = false;
    notifyListeners();
  }

  Future<String> fetchIncidentsReported() async {
    loading = true;
    jwtToken = await storage.read(key: 'jwt');
    Uri url = Uri.parse('$IP_URL/analytics/fetchIncidentsReported');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
      },
    );

    if (response.statusCode == 200) {
      loading = false;
      notifyListeners();

      print("Incidents Reported: ${response.body}");

      return response.body; // Assuming response.body is a String
    } else {
      loading = false;
      notifyListeners();
      throw Exception('Failed to load data');
    }
  }
}
