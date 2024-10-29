import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:safify/models/sub_location.dart';
import 'package:safify/repositories/location_repository.dart';
import 'package:safify/repositories/sublocation_repository.dart';
import 'package:safify/utils/map_utils.dart';

class SubLocationProviderClass extends ChangeNotifier {
  List<SubLocation>? allSubLocations; // All sublocations loaded once
  List<SubLocation>? subLocations; // Sublocations for the selected location
  bool loading = false;
  String? selectedSubLocation;
  String? jwtToken;

  Map<String, List<SubLocation>> locationToSubLocationsMap = {};
  final LocationRepository _locationRepository = LocationRepository();

  final storage = const FlutterSecureStorage();

  /// Fetch sublocations based on location ID, clearing `subLocations` before each fetch
  Future<void> getSubLocationPostData(String locationId) async {
    loading = true;
    subLocations = null; // Clear subLocations to reset the list
    notifyListeners();

    try {
      // Load all sublocations only once
      if (allSubLocations == null) {
        final sublocations =
            await _locationRepository.fetchAllSublocationsFromDb();
        setAllSubLocations(sublocations);
      }

      // Fetch sublocations specific to the selected location
      subLocations = getSubLocationsForLocation(locationId);
    } catch (e) {
      print('Error fetching sublocations: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Sets all sublocations and maps them by location ID
  void setAllSubLocations(List<SubLocation> allSubLocations) {
    this.allSubLocations = allSubLocations;
    locationToSubLocationsMap = makeSublocationMap(allSubLocations);
    notifyListeners();
  }

  /// Gets sublocations specific to the provided location ID
  List<SubLocation> getSubLocationsForLocation(String locationID) {
    return locationToSubLocationsMap[locationID] ?? [];
  }

  /// Set selected sublocation
  void setSubLocationType(selectedVal) {
    selectedSubLocation = selectedVal;
    notifyListeners();
  }
}
