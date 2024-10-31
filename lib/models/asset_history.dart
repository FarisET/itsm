import 'package:flutter/foundation.dart';

class AssetHistory {
  final String reportedBy;
  final String problem;
  final DateTime datetime;
  final String location;
  final String problemCriticality;
  final String? image;
  final String problemStatus;

  AssetHistory({
    required this.reportedBy,
    required this.problem,
    required this.datetime,
    required this.location,
    required this.problemCriticality,
    this.image,
    required this.problemStatus,
  });

  // Factory constructor to create an instance from JSON
  factory AssetHistory.fromJson(Map<String, dynamic> json) {
    return AssetHistory(
      reportedBy: json['Reported by'],
      problem: json['Problem'],
      datetime: DateTime.parse(json['Datetime']),
      location: json['Location'],
      problemCriticality: json['Problem Criticality'],
      image: json['image'],
      problemStatus: json['Problem status'],
    );
  }
}
