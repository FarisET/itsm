class Department {
  final String Department_ID;
  final String Department_Name;

  const Department({
    required this.Department_ID,
    required this.Department_Name,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
        Department_ID: json['department_id'] ?? '',
        Department_Name: json['department_name'] ?? '');
  }
}
