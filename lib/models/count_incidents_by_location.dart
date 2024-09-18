class CountByLocation {
  final String? location_name;
  final int? incident_count;

  const CountByLocation({
    required this.location_name,
    required this.incident_count,
  });

  factory CountByLocation.fromJson(Map<String, dynamic> json) {
    return CountByLocation(
      location_name: json['location_name'] ?? '',
      incident_count: json['incident_count'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'CountByLocation{location_name: $location_name, incident_count: $incident_count}';
  }
}
