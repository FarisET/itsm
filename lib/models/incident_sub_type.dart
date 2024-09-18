class IncidentSubType {
  final String incidentSubtypeId;
  final String incidentSubtypeDescription;
  final String incidentTypeId;

  const IncidentSubType({
    required this.incidentSubtypeId,
    required this.incidentSubtypeDescription,
    required this.incidentTypeId,
  });

  factory IncidentSubType.fromJson(
      Map<String, dynamic> json, String incidentTypeId) {
    return IncidentSubType(
      incidentSubtypeId: json['incident_subtype_id'] ?? '',
      incidentSubtypeDescription: json['incident_subtype_description'] ?? '',
      incidentTypeId: incidentTypeId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'incident_subtype_id': incidentSubtypeId,
      'incident_subtype_description': incidentSubtypeDescription,
      'incident_type_id': incidentTypeId,
    };
  }

  @override
  String toString() {
    return 'IncidentSubType{incidentSubtypeId: $incidentSubtypeId, incidentSubtypeDescription: $incidentSubtypeDescription, incidentTypeId: $incidentTypeId}';
  }
}
