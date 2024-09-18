import 'package:flutter/material.dart';
import 'package:safify/api/locations_data_service.dart';
import 'package:safify/db/database_helper.dart';
import 'package:safify/models/location.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safify/models/sub_location.dart';
import 'package:safify/utils/json_utils.dart';

class LocationRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final storage = const FlutterSecureStorage();
  final LocationsDataService _locationsDataService = LocationsDataService();

  Future<List<Location>> fetchLocationsFromDb() async {
    return await _databaseHelper.getLocations();
  }

  Future<List<SubLocation>> fetchAllSublocationsFromDb() async {
    return await _databaseHelper.getAllSubLocations();
  }

  Future<void> syncDbLocationsAndSublocations() async {
    try {
      final json =
          await _locationsDataService.fetchLocationsAndSublocationsJson();
      final lists = parseLocationsAndSubLocations(json);

      final locations = lists[0] as List<Location>;
      final subLocations = lists[1] as List<SubLocation>;

      await _databaseHelper.insertLocationsAndSublocations(
          locations, subLocations);

      print('Synced locations and sublocations to db');
    } catch (e) {
      debugPrint("Error syncing locations and sublocations to db: $e");
      rethrow;
    }
  }
}
