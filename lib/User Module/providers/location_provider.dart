import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:safify/models/location.dart';
import 'package:safify/repositories/location_repository.dart';

class LocationProviderClass extends ChangeNotifier {
  List<Location>? allLocations;
  bool loading = false;
  String? selectedLocation;
  final LocationRepository _locationRepository = LocationRepository();

  Future<void> fetchLocations() async {
    // loading = true;
    final locationsList = await _locationRepository.fetchLocationsFromDb();
    allLocations = locationsList;
    notifyListeners();
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
