class Announcement {
  final String messageTitle;
  final String messageBody;

  Announcement({required this.messageTitle, required this.messageBody});

  Map<String, dynamic> toJson() {
    return {
      'messageTitle': messageTitle,
      'messageBody': messageBody,
    };
  }
}
