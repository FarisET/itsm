import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:safify/Action%20Team%20Module/pages/admin_analytics.dart';
import 'package:safify/models/action_team_efficiency.dart';
import 'package:safify/repositories/analytics_repository.dart';

import '../../constants.dart';

class ActionTeamEfficiencyProviderClass extends ChangeNotifier {
  List<ActionTeamEfficiency>? actionTeamEfficiency;
  bool loading = false;
  String? jwtToken;
  final storage = const FlutterSecureStorage();
  final AnalyticsRepository _analyticsRepository = AnalyticsRepository();
  Future<List<ActionTeamEfficiency>?> getactionTeamEfficiencyData() async {
    loading = true;
    notifyListeners();

    try {
      // actionTeamEfficiency = await fetchActionTeamEfficiency();
      actionTeamEfficiency =
          await _analyticsRepository.fetchActionTeamEfficiencyAnalyticsFromDb();
      print("action team efficiency: $actionTeamEfficiency");

      loading = false;
      notifyListeners();

      return actionTeamEfficiency;
    } catch (e) {
      loading = false;
      notifyListeners();
      print('Error loading fetchActionTeamEfficiency: $e');
      // You might want to handle the error accordingly
      // throw Exception('Failed to load countByIncidentSubTypes');
      rethrow;
    }
  }

  Future<List<ActionTeamEfficiency>> fetchActionTeamEfficiency() async {
    loading = true;
    notifyListeners();
    //final client = HttpClient();
    jwtToken = await storage.read(key: 'jwt');

    Uri url = Uri.parse('$IP_URL/analytics/fetchEfficiency');
    // client.badCertificateCallback =
    //     (X509Certificate cert, String host, int port) => true;
    // final response = await http.get(url);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
      },
    );
    if (response.statusCode == 200) {
      // Parse the JSON response
      List<dynamic> jsonResponse = jsonDecode(response.body);

      // Ensure that jsonResponse[0] is a List<Map<String, dynamic>>
      if (jsonResponse.isNotEmpty) {
        List<Map<String, dynamic>> incidentsData = (jsonResponse).cast<
            Map<String, dynamic>>(); // Explicitly cast each item in the list

        // Map the incident data to your CountByIncidentSubTypes model
        List<ActionTeamEfficiency> actionTeamEfficiencyList = incidentsData
            .map((item) => ActionTeamEfficiency.fromJson(item))
            .toList();

        loading = false;
        notifyListeners();
        // print("Action Team Efficiency: ${response.body}");
        return actionTeamEfficiencyList;
      } else {
        loading = false;
        notifyListeners();
        throw Exception('Invalid format in JSON response');
      }
    }

    loading = false;
    notifyListeners();
    throw Exception('Failed to load ActionTeamEfficiency');
  }
}
