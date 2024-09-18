import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:safify/constants.dart';
import 'package:safify/models/count_incidents_by_subtype.dart';
import 'package:safify/repositories/analytics_repository.dart';

class CountByIncidentSubTypesProviderClass extends ChangeNotifier {
  List<CountByIncidentSubTypes>? countByIncidentSubTypes;
  bool loading = false;
  String? jwtToken;
  final storage = const FlutterSecureStorage();
  final AnalyticsRepository _analyticsRepository = AnalyticsRepository();

  Future<List<CountByIncidentSubTypes>?>
      getcountByIncidentSubTypesPostData() async {
    loading = true;
    notifyListeners();

    try {
      // countByIncidentSubTypes = await fetchTotalIncidentsOnSubTypes();

      countByIncidentSubTypes =
          await _analyticsRepository.fetchIncidentSubtypeAnalyticsFromDb();

      loading = false;
      notifyListeners();

      return countByIncidentSubTypes;
    } catch (e) {
      loading = false;
      notifyListeners();
      // You might want to handle the error accordingly
      throw Exception('Failed to load countByIncidentSubTypes');
    }
  }

  Future<List<CountByIncidentSubTypes>> fetchTotalIncidentsOnSubTypes() async {
    loading = true;
    notifyListeners();
    try {
      jwtToken = await storage.read(key: 'jwt');
      if (jwtToken == null) {
        throw Exception('JWT token is null');
      }
      Uri url = Uri.parse('$IP_URL/analytics/fetchTotalIncidentsOnSubTypes');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      // Fluttertoast.showToast(
      //   msg: '${response.statusCode}',
      //   toastLength: Toast.LENGTH_SHORT,
      // );

      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> jsonResponse = jsonDecode(response.body);

        // List<CountByLocation> countByIncidentLocationList = jsonResponse
        //     .map((item) =>
        //         CountByLocation.fromJson(item as Map<String, dynamic>))
        //     .toList();

        // Ensure that jsonResponse[0] is a List<Map<String, dynamic>>
        //if (jsonResponse.isNotEmpty && jsonResponse[0] is List<dynamic>) {
        // List<Map<String, dynamic>> incidentsData =
        //     (jsonResponse[0] as List<dynamic>).cast<
        //         Map<String,
        //             dynamic>>(); // Explicitly cast each item in the list

        // Map the incident data to your CountByIncidentSubTypes model
        List<CountByIncidentSubTypes> countByIncidentSubTypesList = jsonResponse
            .map((item) => CountByIncidentSubTypes.fromJson(item))
            .toList();

        loading = false;
        notifyListeners();
        // print("Incidents Subtypes: ${response.body}}");
        return countByIncidentSubTypesList;

        // } else {
        //   loading = false;
        //   notifyListeners();
        //   print('Invalid format in JSON response');
        //   throw Exception('Invalid format in JSON response');
      } else {
        throw Exception('Failed to load countByIncidentSubTypes');
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
