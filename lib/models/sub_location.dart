// ignore_for_file: non_constant_identifier_names

class SubLocation {
  final String location_id;
  final String sublocationId;
  final String sublocationName;
//  final String Incident_Type_ID;

  const SubLocation({
    required this.sublocationId,
    required this.sublocationName,
    required this.location_id,
    //  required this.Incident_Type_ID,
  });

  factory SubLocation.fromJson(Map<String, dynamic> json, String locationID) {
    return SubLocation(
      sublocationId: json['sub_location_id'] ?? '',
      sublocationName: json['sub_location_name'] ?? '',
      location_id: locationID,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub_location_id': sublocationId,
      'sub_location_name': sublocationName,
      'location_id': location_id
      //    'incident_type_id': Incident_Type_ID,
    };
  }

  @override
  String toString() {
    return 'SubLocation{sublocationId: $sublocationId, sublocationName: $sublocationName, location_id: $location_id}';
  }
}
