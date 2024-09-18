class ActionReport {
  String? actionTeamName;
  int? user_report_id;
  int? action_report_id;
  String? report_description;
  String? question_one;
  String? question_two;
  String? question_three;
  String? question_four;
  String? question_five;
  String? resolution_description;
  String? reported_by;
  String? surrounding_image;
  String? proof_image;
  String? date_time;
  String? status;
  String? incident_subtype_description;

  ActionReport(
      {required this.date_time,
      required this.actionTeamName,
      required this.user_report_id,
      required this.action_report_id,
      required this.report_description,
      required this.question_one,
      required this.question_two,
      required this.question_three,
      required this.question_four,
      required this.question_five,
      required this.resolution_description,
      required this.reported_by,
      required this.proof_image,
      required this.surrounding_image,
      required this.status,
      required this.incident_subtype_description});

  factory ActionReport.fromJson(Map<String, dynamic> json) {
    return ActionReport(
        actionTeamName: json['action_team_name'] as String?,
        user_report_id: json['user_report_id'] as int?,
        action_report_id: json['action_report_id'] as int?,
        report_description: json['report_description'] as String?,
        question_one: json['question_one'] as String?,
        question_two: json['question_two'] as String?,
        question_three: json['question_three'] as String?,
        question_four: json['question_four'] as String?,
        question_five: json['question_five'] as String?,
        resolution_description: json['resolution_description'] as String?,
        reported_by: json['reported_by'] as String?,
        proof_image: json['proof_image'] as String?,
        surrounding_image: json['surrounding_image'] as String?,
        date_time: json['date_time'] as String?,
        status: json['status'] as String?,
        incident_subtype_description: json['incident_subtype_description']);
  }

  Map<String, dynamic> toJson() {
    return {
      'action_team_name': actionTeamName,
      'user_report_id': user_report_id,
      'action_report_id': action_report_id,
      'report_description': report_description,
      'question_one': question_one,
      'question_two': question_two,
      'question_three': question_three,
      'question_four': question_four,
      'question_five': question_five,
      'resolution_description': resolution_description,
      'reported_by': reported_by,
      'proof_image': proof_image,
      'surrounding_image': surrounding_image,
      'date_time': date_time,
      'status': status,
      'incident_subtype_description': incident_subtype_description
    };
  }

  @override
  String toString() {
    return 'ActionReport{actionTeamName: $actionTeamName, user_report_id: $user_report_id, action_report_id: $action_report_id, report_description: $report_description, question_one: $question_one, question_two: $question_two, question_three: $question_three, question_four: $question_four, question_five: $question_five, resolution_description: $resolution_description, reported_by: $reported_by, surrounding_image: $surrounding_image, proof_image: $proof_image, date_time: $date_time, status: $status, incident_subtype_description: $incident_subtype_description}';
  }
}
