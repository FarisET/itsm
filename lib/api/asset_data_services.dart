import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safify/constants.dart';

class AssetDataServices {
  final storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> addAssetType(String assetTypeDesc) async {
    String? jwtToken = await storage.read(key: 'jwt');

    Uri url = Uri.parse('$IP_URL/admin/dashboard/addAssetType');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'asset_type_desc': assetTypeDesc,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      return jsonResponse;
    } else {
      // Decode the response body to check for specific error message
      Map<String, dynamic> errorResponse = jsonDecode(response.body);

      // Check for a specific error message and display custom message
      if (errorResponse['error'] == 'This asset type already exists') {
        throw Exception('Asset type already exists.');
      } else {
        throw Exception('Failed to add asset type: ${errorResponse['error']}');
      }
    }
  }

  Future<Map<String, dynamic>> addAsset(
      String assetName, String assetDesc, String assetTypeId) async {
    String? jwtToken = await storage.read(key: 'jwt');

    Uri url = Uri.parse('$IP_URL/admin/dashboard/addAsset');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'asset_name': assetName,
        'asset_desc': assetDesc,
        'asset_type_id': assetTypeId,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      return jsonResponse;
    } else {
      Map<String, dynamic> errorResponse = jsonDecode(response.body);

      if (errorResponse['error'] ==
          'Duplicate entry error or other SQL exception occurred.') {
        throw Exception('Asset already exists.');
      } else {
        throw Exception('Failed to add asset: ${errorResponse['error']}');
      }
    }
  }
}
