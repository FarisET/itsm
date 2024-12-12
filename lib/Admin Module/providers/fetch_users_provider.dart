import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:safify/constants.dart';
import 'package:safify/models/fetch_users.dart';
import 'package:safify/models/user.dart';

class FetchUsersProvider with ChangeNotifier {
  List<FetchUser> _users = [];
  bool _isLoading = false;
  final storage = FlutterSecureStorage();

  List<FetchUser> get users => _users;
  bool get isLoading => _isLoading;

  // Fetch users from the API
  Future<void> fetchUsers() async {
    String? jwtToken = await storage.read(key: 'jwt');

    _isLoading = true;
    notifyListeners();

    final url = Uri.parse(
        '$IP_URL/admin/dashboard/fetchUsers'); // Replace with your API endpoint
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> userData = json.decode(response.body);
        _users = userData.map((json) => FetchUser.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (error) {
      print('Error fetching users: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
