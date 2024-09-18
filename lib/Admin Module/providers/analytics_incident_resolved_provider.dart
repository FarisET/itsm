import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:safify/repositories/analytics_repository.dart';
import '../../constants.dart';

class CountIncidentsResolvedProvider extends ChangeNotifier {
  String? _totalIncidentsResolved;
  bool loading = false;
  String? jwtToken;
  final storage = const FlutterSecureStorage();
  final _analyticsRepository = AnalyticsRepository();

  String? get totalIncidentsResolved => _totalIncidentsResolved;

  getCountResolvedPostData() async {
    loading = true;
    // _totalIncidentsResolved = await fetchIncidentsResolved();
    final val = await _analyticsRepository.fetchTotalIncidentsResolvedFromDb();
    _totalIncidentsResolved = val != null ? val.toString() : "n/a";
    print("Total Incidents Resolved: $_totalIncidentsResolved");
    ;

    loading = false;
    notifyListeners();
  }

  Future<String> fetchIncidentsResolved() async {
    loading = true;
    jwtToken = await storage.read(key: 'jwt');

    Uri url = Uri.parse('$IP_URL/analytics/fetchIncidentsResolved');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
      },
    );
    if (response.statusCode == 200) {
      loading = false;
      notifyListeners();

      print("Incidents Resolved: ${response.body}");

      return response.body; // Assuming response.body is a String
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      loading = false;
      notifyListeners();
      throw Exception('Failed to load data');
    }
  }
}
