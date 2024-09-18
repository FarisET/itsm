import 'package:safify/models/incident_sub_type.dart';
import 'package:safify/models/sub_location.dart';

Map<String, List<SubLocation>> makeSublocationMap(
    List<SubLocation> allSubLocations) {
  Map<String, List<SubLocation>> locationToSubLocationsMap = {};
  for (var subLocation in allSubLocations) {
    if (locationToSubLocationsMap.containsKey(subLocation.location_id)) {
      locationToSubLocationsMap[subLocation.location_id]!.add(subLocation);
    } else {
      locationToSubLocationsMap[subLocation.location_id] = [subLocation];
    }
  }
  return locationToSubLocationsMap;
}

Map<String, List<IncidentSubType>> makeIncidentSubtypeMap(
    List<IncidentSubType> allIncidentSubtypes) {
  Map<String, List<IncidentSubType>> incidentTypeToSubtypeMap = {};
  for (var incidentSubtype in allIncidentSubtypes) {
    if (incidentTypeToSubtypeMap.containsKey(incidentSubtype.incidentTypeId)) {
      incidentTypeToSubtypeMap[incidentSubtype.incidentTypeId]!
          .add(incidentSubtype);
    } else {
      incidentTypeToSubtypeMap[incidentSubtype.incidentTypeId] = [
        incidentSubtype
      ];
    }
  }
  return incidentTypeToSubtypeMap;
}
