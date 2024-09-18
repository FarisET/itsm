// import 'dart:convert';

// import 'package:flutter/widgets.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import 'package:http/http.dart' as http;
// import 'package:safify/constants.dart';
// import 'package:safify/models/location.dart';

// class LocationProviderClass extends ChangeNotifier {
//   List<Location>? LocationPost;
//   bool loading = false;
//   String? selectedLocation;
//   String? jwtToken;
//   final storage = const FlutterSecureStorage();

//   getLocationPostData() async {
//     // loading = true;
//     LocationPost = (await fetchLocations());
//     // loading = false;
//     notifyListeners();
//   }

//   setLocation(selectedVal) {
//     selectedLocation = selectedVal;
//     notifyListeners();
//   }
//   //IPs
//   //stormfiber: 192.168.18.74
//   //mobile data: 192.168.71.223

//   Future<List<Location>> fetchLocations() async {
//     jwtToken = await storage.read(key: 'jwt');
//     loading = true;
//     notifyListeners();
//     Uri url = Uri.parse('$IP_URL/userReport/dashboard/fetchlocations');
//     final response = await http.get(
//       url,
//       headers: {
//         'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
//       },
//     );

//     if (response.statusCode == 200) {
//       List<dynamic> jsonResponse = jsonDecode(response.body) as List<dynamic>;
//       List<Location> incidentList = jsonResponse
//           .map(
//               (dynamic item) => Location.fromJson(item as Map<String, dynamic>))
//           .toList();
//       loading = false;
//       notifyListeners();
//       return incidentList;
//     }
//     loading = false;
//     notifyListeners();
//     throw Exception('Failed to load Location');
//   }
// }

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safify/models/location.dart';
import 'package:safify/repositories/location_repository.dart';

class LocationProvider extends ChangeNotifier {
  List<Location>? allLocations;
  bool loading = false;
  String? selectedLocation;
  final LocationRepository _locationRepository = LocationRepository();

  Future<void> fetchLocations() async {
    // loading = true;
    final locationsList = await _locationRepository.fetchLocationsFromDb();
    allLocations = locationsList;
    // setLocation(locations);
    // loading = false;
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

  // void refresh() async {
  //   final locations = await _locationRepository.fetchLocationsFromDb();
  //   setLocation(locations);
  //   notifyListeners();
  // }
}
