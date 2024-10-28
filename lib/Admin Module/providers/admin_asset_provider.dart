import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:safify/models/asset.dart';
import 'package:safify/models/asset_type.dart';

import '../../constants.dart';

class AdminAssetProvider extends ChangeNotifier {
  List<AssetType>? assetTypeList;
  List<Asset> allAssets = [];
  bool loading = false;
  String? selectedAssetType;
  String? selectedAssetSubtype;
  String? _error;
  String? get error => _error;

  String? jwtToken;
  final storage = const FlutterSecureStorage();

  Future<void> loadAllAssets() async {
    try {
      loading = true;
      notifyListeners();

      // Check and fetch assetTypeList if null
      if (assetTypeList == null) {
        await fetchAssetTypesandSubTypes();
      }

      // Populate allAssets if assetTypeList is successfully fetched
      if (assetTypeList != null) {
        allAssets = assetTypeList!.expand((type) => type.assets).toList();
      } else {
        _error = 'Asset types data is unavailable.';
      }
    } catch (e) {
      _error = 'An error occurred while loading assets: $e';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAssetTypesandSubTypes() async {
    try {
      _error = null;

      loading = true;
      notifyListeners();

      jwtToken = await storage.read(key: 'jwt');
      Uri url = Uri.parse('$IP_URL/admin/dashboard/getAssetsandAssetTypes');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        // Parse the asset types and their corresponding assets (subtypes)
        assetTypeList =
            (jsonResponse['assetTypes'] as List<dynamic>).map((item) {
          return AssetType.fromJson(item);
        }).toList();

        loading = false;
        notifyListeners();
      } else {
        loading = false;
        notifyListeners();
        throw Exception('Failed to load assets and asset types');
      }
    } catch (e) {
      _error = e.toString();
      loading = false;
      notifyListeners();
      rethrow;
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
