import 'dart:convert';

class AssetLog {
  final int assetLogId;
  final String assetNo;
  final String actionUser;
  final String actionPerformed;
  final String actionStatus;
  final DateTime actionDatetime;

  AssetLog({
    required this.assetLogId,
    required this.assetNo,
    required this.actionUser,
    required this.actionPerformed,
    required this.actionStatus,
    required this.actionDatetime,
  });

  // Factory method to create an AssetLog from JSON
  factory AssetLog.fromJson(Map<String, dynamic> json) {
    return AssetLog(
      assetLogId: json['asset_log_id'],
      assetNo: json['asset_no'],
      actionUser: json['action_user'],
      actionPerformed: json['action_performed'],
      actionStatus: json['action_status'],
      actionDatetime: DateTime.parse(json['action_datetime']),
    );
  }
}
