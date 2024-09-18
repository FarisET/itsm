// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:safify/api/locations_data_service.dart';
// import 'package:safify/db/database_helper.dart';
// import 'package:safify/models/location.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:safify/constants.dart';
// import 'package:safify/models/sub_location.dart';
// import 'package:safify/utils/network_util.dart';

// class SublocationRepository {
//   final DatabaseHelper _databaseHelper = DatabaseHelper();
//   final storage = const FlutterSecureStorage();

//   Future<List<SubLocation>> fetchSublocations() async {
//     var pingSuccess = await ping_google();

//     if (!pingSuccess) {
//       print("Could not ping backend, fetching sublocations from local db");
//       final list = await _fetchSublocationsFromDb();
//       return list;
//     } else {
//       try {
//         print("Fetching sublocations from api");
//         final list = await _fetchSublocationsFromApi();
//         return list;
//       } catch (e) {
//         print("Error fetching sublocations from api: $e");
//         final list = await _fetchSublocationsFromDb();
//         return list;
//       }
//     }
//   }

//   Future<List<SubLocation>> _fetchSublocationsFromApi() async {
//     print("getting sublocations from api service");

//     final locationsService = LocationsDataService();
//     final sublocations = await locationsService.fetchSubLocations();
//     return sublocations;
//   }

//   Future<List<SubLocation>> _fetchSublocationsFromDb() async {
//     return await _databaseHelper.getAllSubLocations();
//   }
// }
