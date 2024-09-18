class CountByIncidentSubTypes {
  final String? incident_subtype_description;
  final int? incident_count;

  const CountByIncidentSubTypes({
    required this.incident_subtype_description,
    required this.incident_count,
  });

  factory CountByIncidentSubTypes.fromJson(Map<String, dynamic> json) {
    return CountByIncidentSubTypes(
      incident_subtype_description: json['incident_subtype_description'] ?? '',
      incident_count: json['incident_count'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'CountByIncidentSubTypes{incident_subtype_description: $incident_subtype_description, incident_count: $incident_count}';
  }
}
