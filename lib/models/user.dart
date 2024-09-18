// ignore_for_file: non_constant_identifier_names


class User {
  final String user_name;
  final String user_id;
  final String user_pass;
  final String role;


  User(this.user_name, this.user_id, this.user_pass,this.role); 
  factory User.fromMap(Map<String, dynamic> json) {
    return User(
        json['user_name'], json['user_id'],json['user_pass'],json['role']);
  }
  factory User.fromJson(Map<String, dynamic> json) {
 //       json['user_id'], json['user_pass'],);
  return User(
    json['user_name'],
    json['user_id'],
    json['user_pass'],
    json['role'],
    
  );
  }

  Map<String, dynamic> toJson() => {
        'user_name': user_name,
        'user_id': user_id,
        'user_pass': user_pass,
        'role':role
      };
}