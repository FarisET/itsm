import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:safify/constants.dart';
import 'package:safify/models/asset_details.dart';

class AssetDetailsProvider with ChangeNotifier {
  final storage = FlutterSecureStorage();

  List<AssetDetails> _assetHistory = [];
  String? _errorMessage;
  bool _isLoading = false;
  String? _updateAssetErrorMessage;

  List<AssetDetails> get assetHistory => _assetHistory;
  String? get errorMessage => _errorMessage;
  String? get updateAssetErrorMessage => _updateAssetErrorMessage;
  bool get isLoading => _isLoading;

  Future<void> fetchAssetDetails(String assetNo) async {
    final url = Uri.parse('$IP_URL/admin/dashboard/fetchAssetDetails/$assetNo');
    String? jwtToken = await storage.read(key: 'jwt');

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _assetHistory =
            data.map((json) => AssetDetails.fromJson(json)).toList();
      } else {
        _errorMessage =
            'Error: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateAsset(
      String asset_no,
      String asset_name,
      String asset_desc,
      int asset_type_id,
      String asset_location,
      String status,
      String assignedTo) async {
    final url = Uri.parse('$IP_URL/admin/dashboard/updateAsset');
    String? jwtToken = await storage.read(key: 'jwt');

    _isLoading = true;
    _updateAssetErrorMessage = null;
    notifyListeners();

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'asset_no': asset_no,
          'asset_name': asset_name,
          'asset_desc': asset_desc,
          'asset_type_id': asset_type_id,
          'asset_location': asset_location,
          'status': status,
          'assigned_to': assignedTo,
        }),
      );

      if (response.statusCode == 200) {
        notifyListeners();
        return true;
      } else {
        _updateAssetErrorMessage =
            'Error: ${response.statusCode} - ${response.reasonPhrase}';
        notifyListeners();
        return false;
      }
    } catch (error) {
      _updateAssetErrorMessage = 'An error occurred: $error';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }
}
