// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:safify/api/incident_types_data_service.dart';
// import 'package:safify/db/database_helper.dart';
// import 'package:safify/models/incident_sub_type.dart';
// import 'package:safify/models/incident_types.dart';
// import 'package:safify/utils/network_util.dart';

// class IncidentSubtypesRepository {
//   final DatabaseHelper _databaseHelper = DatabaseHelper();
//   final storage = const FlutterSecureStorage();

//   Future<List<IncidentSubType>> fetchIncidentSubtypes() async {
//     var pingSuccess = await ping_google();

//     if (!pingSuccess) {
//       return _fetchIncidentSubtypesFromDb();
//     } else {
//       try {
//         return await _fetchIncidentSubtypesFromApi();
//       } catch (e) {
//         return _fetchIncidentSubtypesFromDb();
//       }
//     }
//   }

//   Future<List<IncidentSubType>> _fetchIncidentSubtypesFromApi() async {
//     print("getting from api service");

//     final incidentTypesDataService = IncidentTypesDataService();
//     final incidentSubtypes =
//         await incidentTypesDataService.fetchIncidentSubtypes();
//     return incidentSubtypes;
//   }

//   Future<List<IncidentSubType>> _fetchIncidentSubtypesFromDb() async {
//     return await _databaseHelper.getAllIncidentSubtypes();
//   }
// }
