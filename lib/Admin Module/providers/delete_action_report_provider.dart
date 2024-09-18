import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:safify/constants.dart';

class DeleteActionReportProvider extends ChangeNotifier {
  String? jwtToken;
  final storage = const FlutterSecureStorage();
}
