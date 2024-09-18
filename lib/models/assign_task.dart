class AssignTask {
  final int? user_report_id;
  final int? assigned_task_id;
  final String? report_description;
  final String? date_of_assignment;
  final String? sub_location_name;
  final String? incident_subtype_description;
  final String? image;
  final String? incident_criticality_level;
  final String? status;

  AssignTask(
      {required this.user_report_id,
      required this.assigned_task_id,
      required this.report_description,
      required this.date_of_assignment,
      required this.sub_location_name,
      required this.incident_subtype_description,
      required this.image,
      required this.incident_criticality_level,
      required this.status});

  factory AssignTask.fromJson(Map<String, dynamic> json) {
    return AssignTask(
        assigned_task_id: json['assigned_tasks_id'],
        user_report_id: json['user_report_id'],
        report_description: json['report_description'],
        date_of_assignment: json['date_of_assignment'],
        sub_location_name: json['sub_location_name'],
        incident_subtype_description: json['incident_subtype_description'],
        image: json['image'],
        incident_criticality_level: json['incident_criticality_level'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() {
    return {
      'assigned_tasks_id': assigned_task_id,
      'user_report_id': user_report_id,
      'report_description': report_description,
      'date_of_assignment': date_of_assignment,
      'sub_location_name': sub_location_name,
      'incident_subtype_description': incident_subtype_description,
      'image': image,
      'incident_criticality_level': incident_criticality_level,
      'status': status
    };
  }

  @override
  String toString() {
    return 'AssignTask{user_report_id: $user_report_id, assigned_task_id: $assigned_task_id, report_description: $report_description, date_of_assignment: $date_of_assignment, sub_location_name: $sub_location_name, incident_subtype_description: $incident_subtype_description, image: $image, incident_criticality_level: $incident_criticality_level, status: $status}';
  }
}
