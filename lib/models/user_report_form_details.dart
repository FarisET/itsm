class UserReportFormDetails {
  final String? imagePath;
  final String sublocationId;
  final String incidentSubtypeId;
  final String description;
  final DateTime date;
  final String criticalityId;

  UserReportFormDetails({
    this.imagePath,
    required this.sublocationId,
    required this.incidentSubtypeId,
    required this.description,
    required this.date,
    required this.criticalityId,
  });

  Map<String, dynamic> toJson() {
    return {
      'sublocationId': sublocationId,
      'incidentSubtypeId': incidentSubtypeId,
      'description': description,
      'date': date.toIso8601String(),
      'criticalityId': criticalityId,
      'imagePath': imagePath, // stores the image path in json
    };
  }

  factory UserReportFormDetails.fromJson(Map<String, dynamic> json) {
    return UserReportFormDetails(
      sublocationId: json['sublocationId'],
      incidentSubtypeId: json['incidentSubtypeId'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      criticalityId: json['criticalityId'],
      imagePath: json['imagePath'], // retrieves the image path from json
    );
  }

  @override
  String toString() {
    return 'UserFormReport{sublocationId: $sublocationId, incidentSubtypeId: $incidentSubtypeId, description: $description, date: $date, criticalityId: $criticalityId, imagePath: $imagePath}';
  }
}
