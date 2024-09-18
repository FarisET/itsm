import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import 'package:safify/constants.dart';
import 'package:safify/dummy.dart';
import 'package:safify/models/location.dart';
import 'package:safify/models/sub_location.dart';
import 'package:safify/services/UserServices.dart';
import 'package:safify/utils/json_utils.dart';

class LocationsDataService {
  final storage = FlutterSecureStorage();
  List<Location>? _locations;
  List<SubLocation>? _subLocations;

  Future<List<Location>> fetchLocations() async {
    if (_locations == null) {
      final lists = await getLocationsAndSublocations();
      _locations = lists[0] as List<Location>;
      _subLocations = lists[1] as List<SubLocation>;
    }

    return _locations!;
  }

  Future<List<SubLocation>> fetchSubLocations() async {
    if (_subLocations == null) {
      final lists = await getLocationsAndSublocations();
      _locations = lists[0] as List<Location>;
      _subLocations = lists[1] as List<SubLocation>;
    }

    return _subLocations!;
  }

  Future<void> refetchLists() async {
    final lists = await getLocationsAndSublocations();
    _locations = lists[0] as List<Location>;
    _subLocations = lists[1] as List<SubLocation>;
  }

  Future<List<List<dynamic>>> getLocationsAndSublocations() async {
    String? jwtToken = await storage.read(key: 'jwt');
    Uri url =
        Uri.parse('$IP_URL/userReport/dashboard/getLocationsAndSubLocations');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<List<dynamic>> lists = parseLocationsAndSubLocations(jsonResponse);
      return lists;
    } else {
      throw Exception('Failed to load locations from API');
    }
  }

  Future<Map<String, dynamic>> fetchLocationsAndSublocationsJson() async {
    // return locationsJson;

    String? jwtToken = await storage.read(key: 'jwt');
    // final roleName = await UserServices().getRole();
    // print(roleName);
    // final roleEndpoint = roleName == 'admin' ? 'admin' : "userReport";

    // Uri url = Uri.parse(
    //     '$IP_URL/$roleEndpoint/dashboard/getLocationsAndSubLocations');

    Uri url = Uri.parse('$IP_URL/helper/getLocationsAndSubLocations');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // for (var loc in jsonResponse['locations']) {
      //   print(loc);
      // }

      return jsonResponse;
    } else {
      throw Exception('Failed to load locations from API: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> addLocation(String locationName) async {
    String? jwtToken = await storage.read(key: 'jwt');

    Uri url = Uri.parse('$IP_URL/admin/dashboard/addLocationOrSubLocation');

    print({
      'location_name': locationName,
      // 'sub_location_name': null,
      // 'location_id': null,
    });
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'location_name': locationName,
        // 'sub_location_name': null,
        // 'location_id': null,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      return jsonResponse;
    } else {
      throw Exception('Failed to add location: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> addSublocation(
      String locationId, String sublcoationName) async {
    String? jwtToken = await storage.read(key: 'jwt');

    Uri url = Uri.parse('$IP_URL/admin/dashboard/addLocationOrSubLocation');

    print(jsonEncode({
      // 'location_name': null,
      'sub_location_name': sublcoationName,
      'location_id': locationId,
    }));
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        // 'location_name': null,
        'sub_location_name': sublcoationName,
        'location_id': locationId,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to add incident Type: ${response.body}');
    }
  }
}
