class IncidentType {
  final String incidentTypeId;
  final String incidentTypeDescription;

  const IncidentType({
    required this.incidentTypeId,
    required this.incidentTypeDescription,
  });

  factory IncidentType.fromJson(Map<String, dynamic> json) {
    return IncidentType(
        incidentTypeId: json['incident_type_id'] ?? '',
        incidentTypeDescription: json['incident_type_description'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'incident_type_id': incidentTypeId,
      'incident_type_description': incidentTypeDescription,
    };
  }

  @override
  String toString() {
    return 'IncidentType{incidentTypeId: $incidentTypeId, incidentTypeDescription: $incidentTypeDescription}';
  }
}
