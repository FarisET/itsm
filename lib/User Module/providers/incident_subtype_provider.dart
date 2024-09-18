import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:safify/repositories/incident_subtypes_repository.dart';
import 'package:safify/repositories/incident_types_repository.dart';
import 'package:safify/utils/map_utils.dart';

import '../../constants.dart';
import '../../models/incident_sub_type.dart';

class SubIncidentProviderClass extends ChangeNotifier {
  List<IncidentSubType>? subIncidentPost;
  bool loading = false;
  String? jwtToken;
  String? selectedSubIncident;
  List<IncidentSubType>? filteredIncidentSubTypes;
  final storage = const FlutterSecureStorage();

  /// List of all the subtypes of incidents
  List<IncidentSubType>? allSubIncidents;

  Map<String, List<IncidentSubType>> incidentToSubIncidentsMap = {};
  final IncidentTypesRepository _incidentTypesRepository =
      IncidentTypesRepository();

  Future<void> getSubIncidentPostData(String incidentId) async {
    loading = true;

    if (allSubIncidents == null) {
      try {
        final incidentSubtypes =
            // await _incidentSubtypesRepository.fetchIncidentSubtypes();
            await _incidentTypesRepository.fetchAllIncidentSubTypesFromDb();
        setAllIncidentSubTypes(incidentSubtypes);
        notifyListeners();
      } catch (e) {
        print('Error fetching incident subtypes: $e');
      }
    }
    subIncidentPost = getSubIncidentsForIncident(incidentId);
    loading = false;
    notifyListeners();
  }

  void setAllIncidentSubTypes(List<IncidentSubType> allIncidentSubTypes) {
    this.allSubIncidents = allIncidentSubTypes;
    incidentToSubIncidentsMap = makeIncidentSubtypeMap(allIncidentSubTypes);
  }

  void setSubIncidentType(selectedVal) {
    selectedSubIncident = selectedVal;
    notifyListeners();
  }

  List<IncidentSubType> getSubIncidentsForIncident(String incidentID) {
    return incidentToSubIncidentsMap[incidentID] ?? [];
  }

  // void refresh() async {
  //   final incidentSubtypes =
  //       // await _incidentSubtypesRepository.fetchIncidentSubtypes();
  //       await _incidentTypesRepository.fetchAllIncidentSubTypesFromDb();
  //   setAllIncidentSubTypes(incidentSubtypes);
  //   notifyListeners();
  // }
}
