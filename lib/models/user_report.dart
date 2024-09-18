class UserReport {
  final int? userReportId;
  final String? userId;
  final String? reportDescription;
  final String? dateTime;
  // final Stream location;
  final String? subLocationName;
//  final String incidentType;
  final String? subLocationID;
  final String? incidentSubtypeDescription;
  final String? incidentCriticalityLevel;
  final String? incidentCriticalityID;
  final String? image; // You may need to adjust this property's type
  final String? status;

  UserReport(
      {required this.userId,
      required this.userReportId,
      required this.reportDescription,
      required this.dateTime,
      //   required this.location,
      required this.subLocationID,
      required this.subLocationName,
      //  required this.incidentType,
      required this.incidentSubtypeDescription,
      required this.incidentCriticalityLevel,
      required this.incidentCriticalityID,
      required this.image,
      required this.status});

  factory UserReport.fromJson(Map<String, dynamic> json) {
    return UserReport(
      userId: json['user_id'],
      userReportId: json['user_report_id'],
      reportDescription: json['report_description'],
      dateTime: json['date_time'],
      subLocationName: json['sub_location_name'],
      subLocationID: json['sub_location_id'],
      incidentSubtypeDescription: json['incident_subtype_description'],
      incidentCriticalityLevel: json['incident_criticality_level'],
      incidentCriticalityID: json['incident_criticality_id'],
      image: json['image'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_report_id': userReportId,
      'report_description': reportDescription,
      'date_time': dateTime,
      'sub_location_name': subLocationName,
      'sub_location_id': subLocationID,
      'incident_subtype_description': incidentSubtypeDescription,
      'incident_criticality_level': incidentCriticalityLevel,
      'incident_criticality_id': incidentCriticalityID,
      'image': image,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'UserReport{id: $userReportId, user_id: $userId, description: $reportDescription, dateTime: $dateTime, subLocationName: $subLocationName, subLocationID: $subLocationID, incidentSubtypeDescription: $incidentSubtypeDescription, incidentCriticalityLevel: $incidentCriticalityLevel, incidentCriticalityID: $incidentCriticalityID, image: $image, status: $status}';
  }
}
