import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:safify/models/asset.dart';
import 'package:safify/models/asset_type.dart';

import '../../constants.dart';

class AssetProviderClass extends ChangeNotifier {
  List<AssetType>? assetTypeList; // To hold asset types and subtypes (assets)
  bool loading = false;
  String? selectedAssetType;
  String? selectedAssetSubtype;

  String? jwtToken;
  final storage = const FlutterSecureStorage();

  // Fetches the asset types and subtypes from API
  Future<void> fetchAssetTypesandSubTypes() async {
    loading = true;
    notifyListeners();

    jwtToken = await storage.read(key: 'jwt');
    Uri url = Uri.parse('$IP_URL/userReport/dashboard/getAssetsandAssetTypes');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      // Parse the asset types and their corresponding assets (subtypes)
      assetTypeList = (jsonResponse['assetTypes'] as List<dynamic>).map((item) {
        return AssetType.fromJson(item);
      }).toList();

      loading = false;
      notifyListeners();
    } else {
      loading = false;
      notifyListeners();
      throw Exception('Failed to load assets and asset types');
    }
  }

  // Set the selected asset type and reset the selected asset subtype
  void setSelectedAssetType(String? assetTypeId) {
    selectedAssetType = assetTypeId;
    selectedAssetSubtype = null; // Reset the subtype when type changes
    notifyListeners();
  }

  // Set the selected asset subtype
  void setSelectedAssetSubtype(String? assetSubtypeId) {
    selectedAssetSubtype = assetSubtypeId;
    notifyListeners();
  }

  // Method to filter assets (subtypes) based on the selected asset type
  List<Asset> getFilteredAssets(String? selectedAssetTypeId) {
    if (selectedAssetTypeId == null || assetTypeList == null) return [];

    // Find the asset type that matches the selected asset type ID
    AssetType? selectedType = assetTypeList!.firstWhere(
      (type) => type.assetTypeId.toString() == selectedAssetTypeId,
      orElse: () => AssetType(assetTypeId: 0, assetTypeDesc: '', assets: []),
    );

    // Return the list of assets (subtypes) for the selected asset type
    return selectedType.assets ?? [];
  }
}
