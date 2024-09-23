import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:safify/models/search_solution_forum.dart';
import '../../constants.dart';

class SearchSolutionForumProvider extends ChangeNotifier {
  List<SolutionForum>? solutionForum;
  bool loading = false;
  String? jwtToken;
  final storage = const FlutterSecureStorage();

  Future<void> getAllSolutionForumData() async {
    loading = true;
    solutionForum = await fetchAllSolutionForum();
    loading = false;
    notifyListeners();
  }

  Future<List<SolutionForum>> fetchAllSolutionForum() async {
    loading = true;
    notifyListeners();
    jwtToken = await storage.read(key: 'jwt');

    Uri url = Uri.parse('$IP_URL/solutionForum/fetchAllSolutions');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
      },
    );
    //   Fluttertoast.showToast(
    //   msg: '${response.statusCode}',
    //   toastLength: Toast.LENGTH_SHORT,
    // );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body) as List<dynamic>;
      List<SolutionForum> solutionForumList = jsonResponse
          .map((dynamic item) =>
              SolutionForum.fromJson(item as Map<String, dynamic>))
          .toList();
      loading = false;
      notifyListeners();
      print('solutions teams Loaded');
      return solutionForumList;
    }
    loading = false;
    notifyListeners();
    print('Failed to load solutions');
    throw Exception('Failed to load solutions');
  }
}
