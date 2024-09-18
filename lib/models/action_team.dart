class ActionTeam {
  final String ActionTeam_ID;
  final String ActionTeam_Name;
  final String department_name;

  const ActionTeam(
      {required this.ActionTeam_ID,
      required this.ActionTeam_Name,
      required this.department_name});

  factory ActionTeam.fromJson(Map<String, dynamic> json) {
    return ActionTeam(
        ActionTeam_ID: json['action_team_id'] ?? '',
        ActionTeam_Name: json['action_team_name'] ?? '',
        department_name: json['department_name'] ?? '');
  }
}
