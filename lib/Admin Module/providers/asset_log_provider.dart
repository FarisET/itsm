import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:safify/constants.dart';
import 'package:safify/models/asset_log.dart';

class AssetLogProvider with ChangeNotifier {
  final storage = FlutterSecureStorage();

  List<AssetLog> _assetLogs = [];
  String? _errorMessage;
  bool _isLoading = false;

  List<AssetLog> get assetLogs => _assetLogs;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  /// Fetch asset logs by either `asset_no` or `user_report_id`
  Future<void> fetchAssetLogs({String? assetNo, String? userReportId}) async {
    if (assetNo != null && userReportId != null) {
      _errorMessage = 'Error: Only one parameter can be used at a time';
      notifyListeners();
      return;
    }

    // Construct the URL based on which parameter is provided
    String queryParam = '';
    if (assetNo != null) {
      queryParam = 'asset_no=$assetNo';
    } else if (userReportId != null) {
      queryParam = 'user_report_id=$userReportId';
    }

    final url = Uri.parse('$IP_URL/analytics/fetchAssetIssueLogs?$queryParam');
    String? jwtToken = await storage.read(key: 'jwt');

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _assetLogs = data.map((json) => AssetLog.fromJson(json)).toList();
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
}
