import 'package:safify/models/asset.dart';

class AssetType {
  final int assetTypeId;
  final String assetTypeDesc;
  final List<Asset> assets;

  AssetType({
    required this.assetTypeId,
    required this.assetTypeDesc,
    required this.assets,
  });

  factory AssetType.fromJson(Map<String, dynamic> json) {
    return AssetType(
      assetTypeId: json['asset_type_id'],
      assetTypeDesc: json['asset_type_desc'],
      assets: (json['assets'] as List<dynamic>).map((asset) {
        return Asset.fromJson(asset);
      }).toList(),
    );
  }
}
