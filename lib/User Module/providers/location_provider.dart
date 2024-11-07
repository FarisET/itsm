import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:safify/models/location.dart';
import 'package:safify/repositories/location_repository.dart';

class LocationProviderClass extends ChangeNotifier {
  List<Location>? allLocations;
  bool loading = false;
  String? selectedLocation;
  final LocationRepository _locationRepository = LocationRepository();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchLocations() async {
    // loading = true;
    final locationsList = await _locationRepository.fetchLocationsFromDb();
    allLocations = locationsList;
    notifyListeners();
  }

  Future<void> updateLocation(String locationId, String locationName) async {
    setLoading(true);
    notifyListeners(); // Notify UI to show loading

    try {
      await _locationRepository.updateLocation(locationId, locationName);
    } catch (error) {
      // Handle error (could update a specific error state)
      print("Error updating location: $error");
      rethrow; // Rethrow to allow the UI to handle the error if needed
    } finally {
      setLoading(false); // Make sure to stop loading
      notifyListeners(); // Notify UI that loading has finished
    }
  }

  Future<void> deleteLocation(String locationId) async {
    setLoading(true);
    notifyListeners();

    try {
      await _locationRepository.deleteLocation(locationId);
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

  void setLocation(selectedVal) {
    selectedLocation = selectedVal;
    notifyListeners();
  }

  Future<void> SyncDbAndFetchLocations() async {
    try {
      await _locationRepository.syncDbLocationsAndSublocations();
      await fetchLocations();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
