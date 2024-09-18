class ActionReportFormDetails {
  String reportedBy;
  String incidentDesc;
  String? rootCause1;
  String? rootCause2;
  String? rootCause3;
  String? rootCause4;
  String? rootCause5;
  String resolutionDesc;
  String? incidentSiteImgPath;
  String workProofImgPath;
  int userReportId;

  ActionReportFormDetails({
    required this.incidentDesc,
    this.rootCause1,
    this.rootCause2,
    this.rootCause3,
    this.rootCause4,
    this.rootCause5,
    required this.resolutionDesc,
    required this.reportedBy,
    this.incidentSiteImgPath,
    required this.workProofImgPath,
    required this.userReportId,
  });

  Map<String, dynamic> toJson() {
    return {
      'reportedBy': reportedBy,
      'incidentDesc': incidentDesc,
      'rootCause1': rootCause1,
      'rootCause2': rootCause2,
      'rootCause3': rootCause3,
      'rootCause4': rootCause4,
      'rootCause5': rootCause5,
      'resolutionDesc': resolutionDesc,
      'incidentSiteImgPath': incidentSiteImgPath,
      'workProofImgPath': workProofImgPath,
      'userReportId': userReportId,
    };
  }

  factory ActionReportFormDetails.fromJson(Map<String, dynamic> json) {
    return ActionReportFormDetails(
      reportedBy: json['reportedBy'],
      incidentDesc: json['incidentDesc'],
      rootCause1: json['rootCause1'],
      rootCause2: json['rootCause2'],
      rootCause3: json['rootCause3'],
      rootCause4: json['rootCause4'],
      rootCause5: json['rootCause5'],
      resolutionDesc: json['resolutionDesc'],
      incidentSiteImgPath: json['incidentSiteImgPath'],
      workProofImgPath: json['workProofImgPath'],
      userReportId: json['userReportId'],
    );
  }

  @override
  String toString() {
    return 'ActionReportFormDetails{reportedBy: $reportedBy, incidentDesc: $incidentDesc, rootCause1: $rootCause1, rootCause2: $rootCause2, rootCause3: $rootCause3, rootCause4: $rootCause4, rootCause5: $rootCause5, resolutionDesc: $resolutionDesc, incidentSiteImgPath: $incidentSiteImgPath, workProofImgPath: $workProofImgPath, userReportId: $userReportId}';
  }
}
