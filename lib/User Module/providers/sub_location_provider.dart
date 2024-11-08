import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:safify/User%20Module/providers/location_provider.dart';
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
  bool isSearchFocused = false;
  Map<String, List<SubLocation>> locationToSubLocationsMap = {};
  final LocationRepository _locationRepository = LocationRepository();
  final LocationProviderClass locationProvider = LocationProviderClass();
  final storage = const FlutterSecureStorage();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

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

  Future<void> getAllSublocations() async {
    final sublocations = await _locationRepository.fetchAllSublocationsFromDb();
    setAllSubLocations(sublocations);
  }

  /// Gets sublocations specific to the provided location ID
  List<SubLocation> getSubLocationsForLocation(String locationID) {
    return locationToSubLocationsMap[locationID] ?? [];
  }

  List<SubLocation>? getFilteredSubLocations() {
    if (isSearchFocused) {
      return allSubLocations ?? [];
    }
  }

  void setSearchFocus(bool isFocused) {
    isSearchFocused = isFocused;
    notifyListeners();
  }

  bool getSearchFocused() {
    notifyListeners();
    return isSearchFocused;
  }

  /// Set selected sublocation
  void setSubLocationType(selectedVal) {
    selectedSubLocation = selectedVal;
    notifyListeners();
  }

  String? getLocationName(String locationId) {
    // Debugging statements to check data and match issues
    if (locationProvider.allLocations == null ||
        locationProvider.allLocations!.isEmpty) {
      print('allLocations is not loaded or empty.');
      return null;
    }

    print('Looking for location with locationId: $locationId');
    locationProvider.allLocations?.forEach((loc) {
      print(
          'Available locationId: ${loc.locationId}, name: ${loc.locationName}');
    });

    final location = locationProvider.allLocations?.firstWhere(
      (loc) => loc.locationId == locationId,
    );

    if (location == null) {
      print('No matching location found for locationId: $locationId');
    } else {
      print('Found location: ${location.locationName}');
    }

    return location?.locationName;
  }

  Future<void> updateSubLocation(
      String SublocationId, String locationId, String SublocationName) async {
    setLoading(true);
    notifyListeners(); // Notify UI to show loading

    try {
      await _locationRepository.updateSubLocation(
          SublocationId, locationId, SublocationName);
    } catch (error) {
      // Handle error (could update a specific error state)
      print("Error updating location: $error");
      rethrow; // Rethrow to allow the UI to handle the error if needed
    } finally {
      setLoading(false); // Make sure to stop loading
      notifyListeners(); // Notify UI that loading has finished
    }
  }

  Future<void> deleteSubLocation(String locationId) async {
    setLoading(true);
    notifyListeners();

    try {
      await _locationRepository.deleteSubLocation(locationId);
      // Optionally: you can handle a successful deletion here
      print("Location deleted successfully.");
    } catch (error) {
      // Handle error if needed (e.g., show error message)
      print("Error deleting location: $error");
      throw error; // Re-throw the error for the UI to handle
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }
}
