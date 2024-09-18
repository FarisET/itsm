import 'package:safify/models/location.dart';
import 'package:safify/models/sub_location.dart';
import 'package:safify/utils/json_utils.dart';

final locationsJson = {
  "locations": [
    {
      "location_id": "LT1",
      "location_name": "Main Entrance",
      "sub_locations": [
        {"sub_location_id": "SLT1", "sub_location_name": "Reception Desk"},
        {
          "sub_location_id": "SLT2",
          "sub_location_name": "Visitor Waiting Area"
        },
        {"sub_location_id": "SLT3", "sub_location_name": "Security Checkpoint"},
        {"sub_location_id": "SLT4", "sub_location_name": "Information Desk"},
        {"sub_location_id": "SLT5", "sub_location_name": "Entrance Hall"}
      ]
    },
    {
      "location_id": "LT10",
      "location_name": "Maintenance Room",
      "sub_locations": [
        {"sub_location_id": "SLT46", "sub_location_name": "Tool Storage Area"},
        {"sub_location_id": "SLT47", "sub_location_name": "Workbench"},
        {"sub_location_id": "SLT48", "sub_location_name": "Parts Inventory"},
        {
          "sub_location_id": "SLT49",
          "sub_location_name": "Safety Equipment Storage"
        },
        {"sub_location_id": "SLT50", "sub_location_name": "Maintenance Office"}
      ]
    },
    {
      "location_id": "LT11",
      "location_name": "Restrooms",
      "sub_locations": [
        {"sub_location_id": "SLT51", "sub_location_name": "Men Restroom"},
        {"sub_location_id": "SLT52", "sub_location_name": "Women Restroom"},
        {"sub_location_id": "SLT53", "sub_location_name": "Handwash Area"},
        {
          "sub_location_id": "SLT54",
          "sub_location_name": "Restroom Supplies Closet"
        },
        {"sub_location_id": "SLT55", "sub_location_name": "Maintenance Closet"}
      ]
    },
    {
      "location_id": "LT12",
      "location_name": "Break Room",
      "sub_locations": [
        {"sub_location_id": "SLT56", "sub_location_name": "Seating Area"},
        {"sub_location_id": "SLT57", "sub_location_name": "Vending Machines"},
        {"sub_location_id": "SLT58", "sub_location_name": "Kitchenette"},
        {"sub_location_id": "SLT59", "sub_location_name": "Coffee Station"},
        {"sub_location_id": "SLT60", "sub_location_name": "TV Lounge"}
      ]
    },
    {
      "location_id": "LT13",
      "location_name": "Cafeteria",
      "sub_locations": [
        {"sub_location_id": "SLT61", "sub_location_name": "Dining Area"},
        {
          "sub_location_id": "SLT62",
          "sub_location_name": "Food Serving Station"
        },
        {"sub_location_id": "SLT63", "sub_location_name": "Beverage Station"},
        {"sub_location_id": "SLT64", "sub_location_name": "Dish Return Area"},
        {"sub_location_id": "SLT65", "sub_location_name": "Kitchen"}
      ]
    },
    {
      "location_id": "LT14",
      "location_name": "Supervisor Office",
      "sub_locations": [
        {"sub_location_id": "SLT66", "sub_location_name": "Supervisor Desk 1"},
        {"sub_location_id": "SLT67", "sub_location_name": "Supervisor Desk 2"},
        {"sub_location_id": "SLT68", "sub_location_name": "Meeting Table"},
        {"sub_location_id": "SLT69", "sub_location_name": "File Storage"},
        {
          "sub_location_id": "SLT70",
          "sub_location_name": "Office Supplies Cabinet"
        }
      ]
    },
    {
      "location_id": "LT15",
      "location_name": "Manager Office",
      "sub_locations": [
        {"sub_location_id": "SLT71", "sub_location_name": "Manager Desk"},
        {"sub_location_id": "SLT72", "sub_location_name": "Conference Table"},
        {"sub_location_id": "SLT73", "sub_location_name": "File Storage"},
        {"sub_location_id": "SLT74", "sub_location_name": "Visitor Seating"},
        {
          "sub_location_id": "SLT75",
          "sub_location_name": "Office Supplies Cabinet"
        }
      ]
    },
    {
      "location_id": "LT16",
      "location_name": "HR Department",
      "sub_locations": [
        {"sub_location_id": "SLT76", "sub_location_name": "HR Desk 1"},
        {"sub_location_id": "SLT77", "sub_location_name": "HR Desk 2"},
        {"sub_location_id": "SLT78", "sub_location_name": "Interview Room 1"},
        {"sub_location_id": "SLT79", "sub_location_name": "Interview Room 2"},
        {"sub_location_id": "SLT80", "sub_location_name": "HR Filing Cabinet"}
      ]
    },
    {
      "location_id": "LT17",
      "location_name": "Finance Department",
      "sub_locations": [
        {"sub_location_id": "SLT81", "sub_location_name": "Finance Desk 1"},
        {"sub_location_id": "SLT82", "sub_location_name": "Finance Desk 2"},
        {"sub_location_id": "SLT83", "sub_location_name": "Accounting Desk"},
        {
          "sub_location_id": "SLT84",
          "sub_location_name": "Financial Records Storage"
        },
        {"sub_location_id": "SLT85", "sub_location_name": "Conference Table"}
      ]
    },
    {
      "location_id": "LT18",
      "location_name": "IT Department",
      "sub_locations": [
        {"sub_location_id": "SLT86", "sub_location_name": "IT Desk 1"},
        {"sub_location_id": "SLT87", "sub_location_name": "IT Desk 2"},
        {"sub_location_id": "SLT88", "sub_location_name": "Server Rack"},
        {"sub_location_id": "SLT89", "sub_location_name": "Equipment Storage"},
        {"sub_location_id": "SLT90", "sub_location_name": "Help Desk"}
      ]
    },
    {
      "location_id": "LT19",
      "location_name": "R&D Department",
      "sub_locations": [
        {"sub_location_id": "SLT91", "sub_location_name": "Research Desk 1"},
        {"sub_location_id": "SLT92", "sub_location_name": "Research Desk 2"},
        {"sub_location_id": "SLT93", "sub_location_name": "Lab Bench 1"},
        {"sub_location_id": "SLT94", "sub_location_name": "Lab Bench 2"},
        {"sub_location_id": "SLT95", "sub_location_name": "Equipment Storage"}
      ]
    },
    {
      "location_id": "LT2",
      "location_name": "Reception",
      "sub_locations": [
        {
          "sub_location_id": "SLT10",
          "sub_location_name": "Information Counter"
        },
        {"sub_location_id": "SLT6", "sub_location_name": "Reception Desk"},
        {"sub_location_id": "SLT7", "sub_location_name": "Visitor Lounge"},
        {"sub_location_id": "SLT8", "sub_location_name": "Welcome Area"},
        {"sub_location_id": "SLT9", "sub_location_name": "Reception Office"}
      ]
    },
    {
      "location_id": "LT20",
      "location_name": "Conference Room",
      "sub_locations": [
        {
          "sub_location_id": "SLT100",
          "sub_location_name": "Conference Supplies Closet"
        },
        {"sub_location_id": "SLT96", "sub_location_name": "Conference Table"},
        {"sub_location_id": "SLT97", "sub_location_name": "Projector Area"},
        {
          "sub_location_id": "SLT98",
          "sub_location_name": "Presentation Screen"
        },
        {"sub_location_id": "SLT99", "sub_location_name": "Seating Area"}
      ]
    },
    {
      "location_id": "LT3",
      "location_name": "Production Line A",
      "sub_locations": [
        {
          "sub_location_id": "SLT11",
          "sub_location_name": "Assembly Station A1"
        },
        {
          "sub_location_id": "SLT12",
          "sub_location_name": "Assembly Station A2"
        },
        {"sub_location_id": "SLT13", "sub_location_name": "Quality Check A1"},
        {
          "sub_location_id": "SLT14",
          "sub_location_name": "Materials Storage A"
        },
        {"sub_location_id": "SLT15", "sub_location_name": "Supervisor Desk A"}
      ]
    },
    {
      "location_id": "LT4",
      "location_name": "Production Line B",
      "sub_locations": [
        {
          "sub_location_id": "SLT16",
          "sub_location_name": "Assembly Station B1"
        },
        {
          "sub_location_id": "SLT17",
          "sub_location_name": "Assembly Station B2"
        },
        {"sub_location_id": "SLT18", "sub_location_name": "Quality Check B1"},
        {
          "sub_location_id": "SLT19",
          "sub_location_name": "Materials Storage B"
        },
        {"sub_location_id": "SLT20", "sub_location_name": "Supervisor Desk B"}
      ]
    },
    {
      "location_id": "LT5",
      "location_name": "Assembly Area",
      "sub_locations": [
        {"sub_location_id": "SLT21", "sub_location_name": "Assembly Table 1"},
        {"sub_location_id": "SLT22", "sub_location_name": "Assembly Table 2"},
        {"sub_location_id": "SLT23", "sub_location_name": "Tools Rack"},
        {"sub_location_id": "SLT24", "sub_location_name": "Component Bin"},
        {"sub_location_id": "SLT25", "sub_location_name": "Workbench"}
      ]
    },
    {
      "location_id": "LT6",
      "location_name": "Quality Control",
      "sub_locations": [
        {"sub_location_id": "SLT26", "sub_location_name": "Inspection Table 1"},
        {"sub_location_id": "SLT27", "sub_location_name": "Inspection Table 2"},
        {
          "sub_location_id": "SLT28",
          "sub_location_name": "Testing Equipment Area"
        },
        {"sub_location_id": "SLT29", "sub_location_name": "Documentation Desk"},
        {
          "sub_location_id": "SLT30",
          "sub_location_name": "Quality Control Office"
        }
      ]
    },
    {
      "location_id": "LT7",
      "location_name": "Packaging Area",
      "sub_locations": [
        {"sub_location_id": "SLT31", "sub_location_name": "Packing Station 1"},
        {"sub_location_id": "SLT32", "sub_location_name": "Packing Station 2"},
        {"sub_location_id": "SLT33", "sub_location_name": "Materials Storage"},
        {"sub_location_id": "SLT34", "sub_location_name": "Shipping Desk"},
        {"sub_location_id": "SLT35", "sub_location_name": "Labeling Station"}
      ]
    },
    {
      "location_id": "LT8",
      "location_name": "Warehouse",
      "sub_locations": [
        {"sub_location_id": "SLT36", "sub_location_name": "Storage Rack 1"},
        {"sub_location_id": "SLT37", "sub_location_name": "Storage Rack 2"},
        {"sub_location_id": "SLT38", "sub_location_name": "Loading Bay 1"},
        {"sub_location_id": "SLT39", "sub_location_name": "Loading Bay 2"},
        {"sub_location_id": "SLT40", "sub_location_name": "Inventory Office"}
      ]
    },
    {
      "location_id": "LT9",
      "location_name": "Loading Dock",
      "sub_locations": [
        {"sub_location_id": "SLT41", "sub_location_name": "Loading Dock 1"},
        {"sub_location_id": "SLT42", "sub_location_name": "Loading Dock 2"},
        {"sub_location_id": "SLT43", "sub_location_name": "Shipping Office"},
        {"sub_location_id": "SLT44", "sub_location_name": "Forklift Area"},
        {"sub_location_id": "SLT45", "sub_location_name": "Cargo Hold"}
      ]
    }
  ]
};

final incidentTypesJson = {
  "incidentTypes": [
    {
      "incident_type_id": "ITY1",
      "incident_type_description": "safety",
      "incident_subtypes": [
        {
          "incident_subtype_id": "ISTY1",
          "incident_subtype_description": "Physical Injury"
        },
        {
          "incident_subtype_id": "ISTY2",
          "incident_subtype_description": "Near Miss"
        },
        {
          "incident_subtype_id": "ISTY3",
          "incident_subtype_description": "Hazardous Material Spill"
        },
        {
          "incident_subtype_id": "ISTY4",
          "incident_subtype_description": "Fire Situation"
        },
        {
          "incident_subtype_id": "ISTY5",
          "incident_subtype_description": "Accident"
        },
        {
          "incident_subtype_id": "ISTY6",
          "incident_subtype_description": "Electric Hazard"
        }
      ]
    },
    {
      "incident_type_id": "ITY2",
      "incident_type_description": "security",
      "incident_subtypes": [
        {
          "incident_subtype_id": "ISTY10",
          "incident_subtype_description": "Violence"
        },
        {
          "incident_subtype_id": "ISTY11",
          "incident_subtype_description": "Theft"
        },
        {
          "incident_subtype_id": "ISTY12",
          "incident_subtype_description": "Unidentified Vehicle"
        },
        {
          "incident_subtype_id": "ISTY13",
          "incident_subtype_description": "Misuse of Identification"
        },
        {
          "incident_subtype_id": "ISTY14",
          "incident_subtype_description": "False Representation"
        },
        {
          "incident_subtype_id": "ISTY7",
          "incident_subtype_description": "Unauthorized Entry/Access"
        },
        {
          "incident_subtype_id": "ISTY8",
          "incident_subtype_description": "Data Breaches"
        },
        {
          "incident_subtype_id": "ISTY9",
          "incident_subtype_description": "Suspicious Activities"
        }
      ]
    },
    {
      "incident_type_id": "ITY3",
      "incident_type_description": "code of conduct violation",
      "incident_subtypes": [
        {
          "incident_subtype_id": "ISTY15",
          "incident_subtype_description": "Dress Code Violation"
        },
        {
          "incident_subtype_id": "ISTY16",
          "incident_subtype_description": "Indecent Conduct"
        },
        {
          "incident_subtype_id": "ISTY17",
          "incident_subtype_description": "Sexual Misconduct"
        },
        {
          "incident_subtype_id": "ISTY18",
          "incident_subtype_description": "Public Display of Affection"
        },
        {
          "incident_subtype_id": "ISTY19",
          "incident_subtype_description": "Unauthorized Events/Activities"
        },
        {
          "incident_subtype_id": "ISTY20",
          "incident_subtype_description": "Disorderly Conduct"
        },
        {
          "incident_subtype_id": "ISTY21",
          "incident_subtype_description": "Substance Abuse"
        },
        {
          "incident_subtype_id": "ISTY22",
          "incident_subtype_description": "Smoking"
        },
        {
          "incident_subtype_id": "ISTY23",
          "incident_subtype_description":
              "Unauthorized/Distruptive Demonstration"
        },
        {
          "incident_subtype_id": "ISTY24",
          "incident_subtype_description": "Visitor Misconduct"
        }
      ]
    },
    {
      "incident_type_id": "ITY4",
      "incident_type_description": "maintenance",
      "incident_subtypes": [
        {
          "incident_subtype_id": "ISTY25",
          "incident_subtype_description": "Equipment Breakdown"
        },
        {
          "incident_subtype_id": "ISTY26",
          "incident_subtype_description": "Facility Damage"
        },
        {
          "incident_subtype_id": "ISTY27",
          "incident_subtype_description": "Routine Maintenance Tasks"
        },
        {
          "incident_subtype_id": "ISTY28",
          "incident_subtype_description": "Technical Issue"
        }
      ]
    }
  ]
};

final analyticsJsonDummy = {
  "incidents_reported": 98,
  "incidents_resolved": 8,
  "incidents_by_location": [
    {"location_name": "Main Entrance", "incident_count": 30},
    {"location_name": "Maintenance Room", "incident_count": 1},
    {"location_name": "Restrooms", "incident_count": 0},
    {"location_name": "Break Room", "incident_count": 4},
    {"location_name": "Cafeteria", "incident_count": 8},
    {"location_name": "Supervisor Office", "incident_count": 2},
    {"location_name": "Manager Office", "incident_count": 6},
    {"location_name": "HR Department", "incident_count": 12},
    {"location_name": "Finance Department", "incident_count": 15},
    {"location_name": "IT Department", "incident_count": 10},
    {"location_name": "R&D Department", "incident_count": 4},
    {"location_name": "Reception", "incident_count": 1},
    {"location_name": "Conference Room", "incident_count": 0},
    {"location_name": "Production Line A", "incident_count": 0},
    {"location_name": "Production Line B", "incident_count": 2},
    {"location_name": "Assembly Area", "incident_count": 1},
    {"location_name": "Quality Control", "incident_count": 0},
    {"location_name": "Packaging Area", "incident_count": 2}
  ],
  "incidents_by_subtype": [
    {"incident_subtype_description": "Physical Injury", "incident_count": 28},
    {"incident_subtype_description": "Near Miss", "incident_count": 14},
    {
      "incident_subtype_description": "Dress Code Violation",
      "incident_count": 13
    },
    {"incident_subtype_description": "Theft", "incident_count": 5},
    {"incident_subtype_description": "Violence", "incident_count": 4},
    {
      "incident_subtype_description": "Hazardous Material Spill",
      "incident_count": 4
    },
    {"incident_subtype_description": "Electric Hazard", "incident_count": 4},
    {
      "incident_subtype_description": "Unidentified Vehicle",
      "incident_count": 4
    },
    {"incident_subtype_description": "Indecent Conduct", "incident_count": 3},
    {"incident_subtype_description": "Disorderly Conduct", "incident_count": 3},
    {
      "incident_subtype_description": "Equipment Breakdown",
      "incident_count": 3
    },
    {
      "incident_subtype_description": "Public Display of Affection",
      "incident_count": 2
    },
    {"incident_subtype_description": "Accident", "incident_count": 2},
    {"incident_subtype_description": "Fire Situation", "incident_count": 2}
  ],
  "action_team_efficiency": [
    {"action_team_name": "Main Entrance Security", "efficiency_value": "4.76"},
    {"action_team_name": "Cafeteria Cafe Services", "efficiency_value": "0.00"},
    {"action_team_name": "Cafeteria Maintenance", "efficiency_value": "0.00"},
    {"action_team_name": "Loading Dock IT", "efficiency_value": "0.00"},
    {
      "action_team_name": "Loading Dock Maintenance",
      "efficiency_value": "0.00"
    },
    {"action_team_name": "Loading Dock Security", "efficiency_value": "0.00"},
    {"action_team_name": "Production Line A IT", "efficiency_value": "0.00"},
    {
      "action_team_name": "Production Line A Maintenance",
      "efficiency_value": "0.00"
    },
    {
      "action_team_name": "Production Line A Security",
      "efficiency_value": "0.00"
    },
    {"action_team_name": "Production Line B IT", "efficiency_value": "0.00"},
    {
      "action_team_name": "Production Line B Maintenance",
      "efficiency_value": "0.00"
    },
    {"action_team_name": "Main Entrance Medical", "efficiency_value": "70.52"},
    {
      "action_team_name": "Production Line B Security",
      "efficiency_value": "0.00"
    }
  ]
};
void main(List<String> args) {
  // final locationsAndSubLocations = parseLocationsAndSubLocations(locationsJson);
  // final locations = locationsAndSubLocations[0];
  // final subLocations = locationsAndSubLocations[1];

  final incidents = parseIncidentAndSubIncidentTypes(incidentTypesJson);
  final incidentTypes = incidents[0];
  final incidentSubTypes = incidents[1];

  // Print the map
  incidentTypes.forEach((incidentType) {
    incidentSubTypes.forEach((incidentSubType) {
      if (incidentSubType.incidentTypeId == incidentType.incidentTypeId) {
        // print('   $incidentSubType');
      }
    });
  });

  // // Print the map
  // locationToSubLocationsMap.forEach((locationId, subLocationsList) {
  //   print('Location ID: $locationId');
  //   subLocationsList.forEach((subLocation) {
  //     print('   $subLocation');
  //   });
  // });

  // print('Locations:');
  // for (var location in locations) {
  //   print(location);
  // }

  // print('\nSub Locations:');
  // for (var subLocation in subLocations) {
  //   print(subLocation);
  // }

  // print("count of locations: ${locations.length}");
  // print("count of sub locations: ${subLocations.length}");
  // call();
}
