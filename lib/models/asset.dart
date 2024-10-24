class Asset {
  final String? assetNo;
  final String? assetName;
  final int? assetIssueCount;

  Asset({
    this.assetNo,
    this.assetName,
    this.assetIssueCount,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      assetNo: json['asset_no'],
      assetName: json['asset_name'],
      assetIssueCount: json['asset_issue_count'],
    );
  }
}
