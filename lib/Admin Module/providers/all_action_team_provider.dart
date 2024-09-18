import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../../models/action_team.dart';

class AllActionTeamProviderClass extends ChangeNotifier {
  List<ActionTeam>? allActionTeams;
  bool loading = false;
  String? selectedActionTeam;
  String? jwtToken;
  final storage = const FlutterSecureStorage();

  Future<void> fetchAllActionTeams() async {
    loading = true;
    notifyListeners();
    jwtToken = await storage.read(key: 'jwt');

    Uri url =
        Uri.parse('$IP_URL/admin/dashboard/fetchAllActionTeamsWithDepartments');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body) as List<dynamic>;
      allActionTeams = jsonResponse
          .map((dynamic item) =>
              ActionTeam.fromJson(item as Map<String, dynamic>))
          .toList();
      loading = false;
      notifyListeners();
    } else {
      loading = false;
      notifyListeners();
      throw Exception('Failed to load action teams');
    }
  }

  void setActionTeam(selectedVal) {
    selectedActionTeam = selectedVal;
    notifyListeners();
  }
}
