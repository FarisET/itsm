import 'package:flutter/widgets.dart';
import 'package:safify/models/incident_types.dart';
import 'package:safify/repositories/incident_types_repository.dart';

class IncidentProviderClass extends ChangeNotifier {
  List<IncidentType>? incidentTypes;
  bool loading = false;
  String? selectedIncidentType;
  final IncidentTypesRepository _incidentTypesRepository =
      IncidentTypesRepository();

  getIncidentPostData() async {
    // loading = true;
    incidentTypes = await _incidentTypesRepository.fetchIncidentTypesFromDb();
    // loading = false;
    notifyListeners();
  }

  setIncidentType(selectedVal) {
    selectedIncidentType = selectedVal;
    notifyListeners();
  }

  Future<void> syncDbAndFetchIncidentTypes() async {
    try {
      await _incidentTypesRepository.syncDbIncidentAndSubincidentTypes();
      getIncidentPostData();
    } catch (e) {
      rethrow;
    }
  }

  // void refresh() async {
  //   final incidentTypes = await _incidentTypesRepository.fetchIncidentTypesFromDb();
  //   setIncidentType(incidentTypes);
  //   notifyListeners();
  // }

  //IPs
  //stormfiber: 192.168.18.74
  //mobile data: 192.168.71.223
}
