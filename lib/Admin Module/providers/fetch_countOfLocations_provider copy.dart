import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:safify/models/count_incidents_by_location.dart';
import 'package:safify/repositories/analytics_repository.dart';

import '../../constants.dart';

class CountByLocationProviderClass extends ChangeNotifier {
  List<CountByLocation>? countByLocation;
  bool loading = false;
  String? jwtToken;
  final storage = const FlutterSecureStorage();
  final AnalyticsRepository _analyticsRepository = AnalyticsRepository();

  Future<List<CountByLocation>?> getcountByIncidentLocationPostData() async {
    loading = true;
    notifyListeners();

    try {
      // countByLocation = await fetchTotalIncidentsLocation();
      countByLocation =
          await _analyticsRepository.fetchIncidentLocationAnalyticsFromDb();
      loading = false;
      notifyListeners();

      return countByLocation;
    } catch (e) {
      loading = false;
      notifyListeners();
      print('Error fetching count by location: $e');
      throw Exception('Failed to load count by location subtypes');
    }
  }

  Future<List<CountByLocation>?> fetchTotalIncidentsLocation() async {
    loading = true;
    notifyListeners();

    try {
      jwtToken = await storage.read(key: 'jwt');
      if (jwtToken == null) {
        throw Exception('JWT token is null');
      }

      Uri url = Uri.parse('$IP_URL/analytics/fetchTotalIncidentsOnLocations');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);

        List<CountByLocation> countByIncidentLocationList = jsonResponse
            .map((item) =>
                CountByLocation.fromJson(item as Map<String, dynamic>))
            .toList();

        loading = false;
        notifyListeners();
        // print("Count by location: ${response.body}");
        return countByIncidentLocationList;
      } else {
        throw Exception('Failed to load countByIncidentLocations');
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
