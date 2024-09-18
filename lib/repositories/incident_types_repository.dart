import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safify/api/incident_types_data_service.dart';
import 'package:safify/db/database_helper.dart';
import 'package:safify/models/incident_sub_type.dart';
import 'package:safify/models/incident_types.dart';
import 'package:safify/utils/json_utils.dart';
import 'package:safify/utils/network_util.dart';

class IncidentTypesRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final storage = const FlutterSecureStorage();
  final IncidentTypesDataService _incidentTypesDataService =
      IncidentTypesDataService();

  // Future<List<IncidentType>> fetchIncidentTypes() async {
  //   var pingSuccess = await ping_google();

  //   if (!pingSuccess) {
  //     return _fetchIncidentTypesFromDb();
  //   } else {
  //     try {
  //       return await _fetchIncidentTypesFromApi();
  //     } catch (e) {
  //       return _fetchIncidentTypesFromDb();
  //     }
  //   }
  // }

  // Future<List<IncidentType>> _fetchIncidentTypesFromApi() async {
  //   print("getting from api service");

  //   final incidentTypesDataService = IncidentTypesDataService();
  //   final incidentTypes = await incidentTypesDataService.fetchIncidentTypes();
  //   return incidentTypes;
  // }

  Future<List<IncidentType>> fetchIncidentTypesFromDb() async {
    return await _databaseHelper.getIncidentTypes();
  }

  Future<List<IncidentSubType>> fetchAllIncidentSubTypesFromDb() async {
    return await _databaseHelper.getAllIncidentSubtypes();
  }

  Future<void> syncDbIncidentAndSubincidentTypes() async {
    try {
      final json =
          await _incidentTypesDataService.fetchIncidentTypesAndSubtypesJson();
      final lists = parseIncidentAndSubIncidentTypes(json);

      final incidentTypes = lists[0] as List<IncidentType>;
      final incidentSubTypes = lists[1] as List<IncidentSubType>;

      await _databaseHelper.insertIncidentAndSubincidentTypes(
          incidentTypes, incidentSubTypes);

      print('Synced incident and subincident types to db');
    } catch (e) {
      print("Error syncing incident and subincident types to db: $e");
      rethrow;
    }
  }
}
