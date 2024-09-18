import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safify/widgets/notification_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class UserServices {
  String? jwtToken;
  final storage = const FlutterSecureStorage();
  Notifications notifications = Notifications();
  Future<void> storeJwtAndRoleAndDevToken(
      String jwt, String role, String userName, String deviceToken) async {
    await storage.write(key: 'jwt', value: jwt);
    await storage.write(key: 'role_name', value: role);
    await storage.write(key: 'user_name', value: userName);
    await storage.write(key: 'device_token', value: deviceToken);
  }

  Future<String?> getJwt() async {
    return await storage.read(key: 'jwt');
  }

  Future<String?> getRole() async {
    return await storage.read(key: 'role_name');
  }

  Future<String?> getName() async {
    return await storage.read(key: 'user_name');
  }

  Future<String?> getDevToken() async {
    return await storage.read(key: 'device_token');
  }

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString("user_id");
    Uri url = Uri.parse('$IP_URL/user/logout');
    try {
      final http.Response response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          <String, String>{
            "user_id": user_id!,
          },
        ),
      );
      if (response.statusCode == 200) {
        await storage.delete(key: 'jwt');
        await storage.delete(key: 'role_name');
        await storage.delete(key: 'device_token');
        prefs.remove("user_id");
        return true;
      } else {
        throw Exception("Logout Failed: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> login(String id, String password) async {
    Uri url = Uri.parse('$IP_URL/user/login');
    try {
      String? deviceToken = await notifications.updateTokenToServer();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('loginTime', DateTime.now().millisecondsSinceEpoch);

      if (deviceToken == null) {
        return {'success': false, 'message': 'Failed to get device token'};
      }

      final http.Response response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          <String, String>{
            "user_id": id,
            "user_pass": password,
            "device_token": deviceToken,
          },
        ),
      );

      final responseJson = json.decode(response.body);
      final status = responseJson['status'];
      final token = responseJson['token'];
      final error = responseJson['error'];

      // print('error: $error');
      // print('status: $status');

      if (response.statusCode == 200) {
        if (token != null) {
          final decodedToken = parseJwt(token);
          String? role = decodedToken['role_name'];
          String? userName = decodedToken['user_name'];

          if (role != null) {
            await storeJwtAndRoleAndDevToken(
                token, role, userName!, deviceToken);
            return {'success': true};
          }
        }
      } else if (response.statusCode == 401) {
        return {'success': false, 'message': status};
      } else if (response.statusCode == 500) {
        if (error.contains(
            "This Account is Already Logged in From Another Device")) {
          return {
            'success': false,
            'message': "Already logged in from another device"
          };
        } else if (error.contains("Authentication failed")) {
          return {'success': false, 'message': "Authentication failed"};
        } else if (error.contains("Wrong Password")) {
          return {'success': false, 'message': "Incorrect password"};
        } else if (error.contains("Incorrect User ID")) {
          return {'success': false, 'message': "Incorrect Username"};
        } else if (error.contains("Wait for")) {
          return {'success': false, 'message': error};
        }
      }
    } catch (e) {
      print('exception:$e');
      return {'success': false, 'message': '$e'};
    }

    return {'success': false, 'message': 'Unknown error occurred'};
  }

  Future<int> createUser(
      String userid, String username, String password, String role) async {
    try {
      jwtToken = await storage.read(key: 'jwt');

      Uri url = Uri.parse('$IP_URL/admin/dashboard/createUser');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $jwtToken'
        },
        body: jsonEncode(
          <String, dynamic>{
            "user_id": userid,
            "user_pass": password,
            "user_name": username,
            "role_name": role,
          },
        ),
      );
      final responseBody = jsonDecode(response.body);
      final status = responseBody['message'];

      if (response.statusCode == 200) {
        return 1;
      }
    } catch (e) {
      print('Error posting approved action report: $e');
      throw Exception('Failed to post approved action report');
    }
    return 0;
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('Invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!');
    }

    return utf8.decode(base64Url.decode(output));
  }
}
