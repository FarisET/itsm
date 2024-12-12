class FetchUser {
  final String user_name;
  final String user_id;

  FetchUser(this.user_name, this.user_id);
  factory FetchUser.fromMap(Map<String, dynamic> json) {
    return FetchUser(json['user_name'], json['user_id']);
  }
  factory FetchUser.fromJson(Map<String, dynamic> json) {
    //       json['user_id'], json['user_pass'],);
    return FetchUser(
      json['user_name'],
      json['user_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'user_name': user_name,
        'user_id': user_id,
      };
}
