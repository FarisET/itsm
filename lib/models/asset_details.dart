class AssetDetails {
  final String assetNo;
  final String assetName;
  final String assetDesc;
  final String assetType;
  final int assetTypeId;
  final DateTime assetCreationDate;
  final String status;
  final int assetIssueCount;
  final String isActive;
  final String assignedTo;
  final String userName;
  final String assetLocation;
  final String locationName;
  final String assetSubLocationId;

  AssetDetails({
    required this.assetNo,
    required this.assetName,
    required this.assetDesc,
    required this.assetType,
    required this.assetTypeId,
    required this.assetCreationDate,
    required this.status,
    required this.assetIssueCount,
    required this.isActive,
    required this.assignedTo,
    required this.userName,
    required this.assetLocation,
    required this.locationName,
    required this.assetSubLocationId,
  });

  factory AssetDetails.fromJson(Map<String, dynamic> json) {
    return AssetDetails(
      assetNo: json['asset_no'] ?? '',
      assetName: json['asset_name'] ?? '',
      assetDesc: json['asset_desc'] ?? '',
      assetType: json['asset_type'] ?? '',
      assetTypeId: json['asset_type_id'] ?? '',
      assetCreationDate: DateTime.parse(json['asset_creation_date']),
      status: json['asset_status'] ?? '',
      assetIssueCount: json['asset_issue_count'] ?? 0,
      isActive: json['is_active'] ?? '',
      assignedTo: json['assigned_to'] ?? '',
      userName: json['user_name'] ?? '',
      assetLocation: json['asset_location'] ?? '',
      assetSubLocationId: json['asset_location_id'] ?? '',
      locationName: json['location_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asset_no': assetNo,
      'asset_name': assetName,
      'asset_desc': assetDesc,
      'asset_type': assetType,
      'asset_creation_date': assetCreationDate.toIso8601String(),
      'status': status,
      'asset_issue_count': assetIssueCount,
      'is_active': isActive,
      'assigned_to': assignedTo,
      'user_name': userName,
      'asset_location': assetLocation,
      'location_name': locationName,
      'asset_location_id': assetSubLocationId
    };
  }
}
