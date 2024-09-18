class Location {
  final String locationId;
  final String locationName;

  const Location({
    required this.locationId,
    required this.locationName,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        locationId: json['location_id'] ?? '',
        locationName: json['location_name'] ?? '');
  }
  Map<String, dynamic> toJson() {
    return {
      'location_id': locationId,
      'location_name': locationName,
    };
  }

  @override
  String toString() {
    return 'Location{locationId: $locationId, locationName: $locationName}';
  }
}
