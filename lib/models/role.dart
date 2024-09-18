class Role {
  final String role_name;
  final String role_id;

  Role(this.role_id, this.role_name);
  factory Role.fromMap(Map<String, dynamic> json) {
    return Role(json['role_name'], json['role_id']);
  }
  factory Role.fromJson(Map<String, dynamic> json) {
    //       json['user_id'], json['user_pass'],);
    return Role(
      json['role_name'],
      json['role_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'role_name': role_name,
        'role_id': role_id,
      };
}
