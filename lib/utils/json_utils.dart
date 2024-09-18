import 'package:safify/models/incident_sub_type.dart';
import 'package:safify/models/incident_types.dart';
import 'package:safify/models/location.dart';
import 'package:safify/models/sub_location.dart';

List<List> parseLocationsAndSubLocations(Map<String, dynamic> locationsJson) {
  List<Location> locations = [];
  List<SubLocation> subLocations = [];

  for (var locationJson in locationsJson['locations']) {
    Location location = Location.fromJson(locationJson);
    locations.add(location);

    if (locationJson.containsKey('sub_locations')) {
      for (var subLocationJson in locationJson['sub_locations']) {
        SubLocation subLocation =
            SubLocation.fromJson(subLocationJson, location.locationId);
        subLocations.add(subLocation);
      }
    }
  }

  return [locations, subLocations];
}

List<List> parseIncidentAndSubIncidentTypes(
    Map<String, dynamic> incidentTypesJson) {
  List<IncidentType> incidentTypes = [];
  List<IncidentSubType> subIncidentTypes = [];

  for (var incidentTypeJson in incidentTypesJson['incidentTypes']) {
    IncidentType incidentType = IncidentType.fromJson(incidentTypeJson);
    incidentTypes.add(incidentType);

    if (incidentTypeJson.containsKey('incident_subtypes')) {
      for (var subIncidentTypeJson in incidentTypeJson['incident_subtypes']) {
        IncidentSubType subIncidentType = IncidentSubType.fromJson(
            subIncidentTypeJson, incidentType.incidentTypeId);
        subIncidentTypes.add(subIncidentType);
      }
    }
  }

  return [incidentTypes, subIncidentTypes];
}

//  "incident_type_id": "ITY4",
//       "incident_type_description": "maintenance",
//       "incident_subtypes": [
//         {
//           "incident_subtype_id": "ISTY25",
//           "incident_subtype_description": "Equipment Breakdown"
//         },
//         {
//           "incident_subtype_id": "ISTY26",
//           "incident_subtype_description": "Facility Damage"
//         },
//         {
//           "incident_subtype_id": "ISTY27",
//           "incident_subtype_description": "Routine Maintenance Tasks"
//         },
//         {
//           "incident_subtype_id": "ISTY28",
//           "incident_subtype_description": "Technical Issue"
//         }
//       ]
//     }