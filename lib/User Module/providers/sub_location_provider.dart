import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:safify/models/sub_location.dart';
import 'package:safify/repositories/location_repository.dart';
import 'package:safify/repositories/sublocation_repository.dart';
import 'package:safify/utils/map_utils.dart';

class SubLocationProviderClass extends ChangeNotifier {
  List<SubLocation>? allSubLocations;

  /// List of all sublocations for the selected location
  List<SubLocation>? subLocations;
  bool loading = false;
  String? selectedSubLocation;
  String? jwtToken;

  Map<String, List<SubLocation>> locationToSubLocationsMap = {};
  final LocationRepository _locationRepository = LocationRepository();

  final storage = const FlutterSecureStorage();

  Future<void> getSubLocationPostData(String locationId) async {
    loading = true;
    if (allSubLocations == null) {
      try {
        final sublocations =
            await _locationRepository.fetchAllSublocationsFromDb();
        setAllSubLocations(sublocations);
      } catch (e) {
        print('Error fetching sublocations: $e');
      }
    }

    subLocations = getSubLocationsForLocation(locationId);
    loading = false;
    notifyListeners();
  }

  void setSubLocationType(selectedVal) {
    selectedSubLocation = selectedVal;
    notifyListeners();
  }

  void setAllSubLocations(List<SubLocation> allSubLocations) {
    this.allSubLocations = allSubLocations;
    locationToSubLocationsMap = makeSublocationMap(allSubLocations);

    notifyListeners();
  }

  List<SubLocation> getSubLocationsForLocation(String locationID) {
    return locationToSubLocationsMap[locationID] ?? [];
  }

  // Future<void> refresh() async {
  //   final list = await _locationRepository.fetchAllSublocationsFromDb();
  //   setAllSubLocations(list);
  //   notifyListeners();
  // }
}
