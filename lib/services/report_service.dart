import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safify/constants.dart';
import 'package:safify/models/action_report_form_details.dart';
import 'package:safify/models/assign_task.dart';
import 'package:safify/models/token_expired.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class ReportServices {
  // final BuildContext context; // Include the BuildContext in the constructor

  ReportServices();
  // Constructor for ReportServices
  String? current_user_id;
  String? jwtToken;
  final storage = const FlutterSecureStorage();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Fetches current user's user-reports from the API
  Future<List<Map<String, dynamic>>> fetchUserReports() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentUserId = prefs.getString("user_id");
      String? jwtToken = await storage.read(key: 'jwt');

      if (currentUserId == null || jwtToken == null) {
        throw Exception('User ID or JWT token not found.');
      }

      Uri url =
          Uri.parse('$IP_URL/userReport/dashboard/$currentUserId/reports');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);

        final list =
            jsonResponse.map((e) => e as Map<String, dynamic>).toList();
        return list;

        // List<UserReport> reportList = jsonResponse
        //     .map((dynamic item) => UserReport.fromJson(item))
        //     .toList();

        // return reportList;
      } else {
        final responseBody = jsonDecode(response.body);
        final status = responseBody['message'];

        if (status.contains('Invalid token.') ||
            status.contains('Access denied')) {
          throw TokenExpiredException('Error: $status');
        } else {
          throw Exception('Error: $status');
        }
      }
    } catch (e) {
      if (e is TokenExpiredException) {
        // Preserve the TokenExpiredException and rethrow it
        throw e;
      } else {
        // Catch-all for other exceptions
        throw Exception('Failed to load Reports');
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchAssignedReports() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      current_user_id = prefs.getString('user_id');
      jwtToken = await storage.read(key: 'jwt');
      //jwtToken = 'd-uyhhfg';
      Uri url = Uri.parse(
          '$IP_URL/actionTeam/dashboard/$current_user_id/fetchAssignedTasks');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
        },
      );
      if (response.statusCode == 200) {
        // print('Response: ${response.body}');
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<AssignTask> reportList =
            jsonResponse.map((item) => AssignTask.fromJson(item)).toList();

        return jsonResponse.map((e) => e as Map<String, dynamic>).toList();
      } else {
        final responseBody = jsonDecode(response.body);
        final status = responseBody['message'];

        if (status.contains('Invalid token.') ||
            status.contains('Access denied')) {
          throw TokenExpiredException('Error: $status');
        } else {
          throw Exception('Error: $status');
        }
      }
    } catch (e) {
      if (e is TokenExpiredException) {
        // Preserve the TokenExpiredException and rethrow it
        rethrow;
      } else {
        // Catch-all for other exceptions
        rethrow;
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchAdminUserReports() async {
    try {
      jwtToken = await storage.read(key: 'jwt');
      Uri url = Uri.parse('$IP_URL/admin/dashboard/fetchAllUserReports');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken', // Include JWT token in headers
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body) as List<dynamic>;
        // debugPrint('jsonResponse: $jsonResponse');

        // List<UserReport> allReportList = jsonResponse
        //     .map((dynamic item) =>
        //         UserReport.fromJson(item as Map<String, dynamic>))
        //     .toList();
        // return allReportList;

        final list =
            jsonResponse.map((e) => e as Map<String, dynamic>).toList();
        return list;
      } else {
        final responseBody = jsonDecode(response.body);
        final status = responseBody['message'];

        if (status.contains('Invalid token.') ||
            status.contains('Access denied')) {
          throw TokenExpiredException('Error: $status');
        } else {
          throw Exception('Error: $status');
        }
      }
    } catch (e) {
      if (e is TokenExpiredException) {
        // Preserve the TokenExpiredException and rethrow it
        throw e;
      } else {
        // Catch-all for other exceptions
        throw Exception('Failed to load Reports');
      }
    }
  }

  Future<bool> postapprovedActionReport(
      int? user_report_id, int? action_report_id) async {
    try {
      jwtToken = await storage.read(key: 'jwt');

      Uri url = Uri.parse('$IP_URL/admin/dashboard/approvedActionReport');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $jwtToken'
        },
        body: jsonEncode(
          <String, dynamic>{
            "user_report_id": user_report_id,
            "action_report_id": action_report_id,
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to post approved action report: ${response.body}");
        return false;
      }
    } catch (e) {
      print('Error posting approved action report: $e');
      // throw Exception('Failed to post approved action report');
      return false;
    }
  }

  Future<int> postReport(String sublocation, String incidentSubType,
      String description, DateTime date, String risklevel) async {
    try {
      jwtToken = await storage.read(key: 'jwt');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      current_user_id = prefs.getString("user_id");
      print('current_user_id:$current_user_id');
      Uri url =
          Uri.parse('$IP_URL/userReport/dashboard/$current_user_id/MakeReport');

      final http.Response response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $jwtToken'
        },
        body: jsonEncode(
          <String, dynamic>{
            "image": null,
            "incident_subtype_id": incidentSubType,
            "sub_location_id": sublocation,
            "report_description": description,
            "date_time": date
                .toLocal()
                .toIso8601String()
                .split(".")[0], // Serialize DateTime to string
            "incident_criticality_id": risklevel
          },
        ),
      );
      final msg = json.decode(response.body)['message'];

      if (response.statusCode == 200) {
        return 1;
      } else if (response.statusCode == 500) {
        return 0;
      } else if (msg == 'Invalid token.' ||
          msg == 'Access denied. User role is not authorized.' ||
          msg == 'Access denied, no token provided.') {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => LoginPage()),
        // );
        throw Exception('Error: $msg');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: '$e',
        toastLength: Toast.LENGTH_SHORT,
      );
      print('Error posting report: $e');
      return 0;
    }
    return 0;
  }

  Future<int> uploadReportWithImage(
      // File? imageFile,
      String? filePath,
      String sublocationId,
      String incidentSubtypeId,
      String description,
      DateTime date,
      String criticalityId) async {
    jwtToken = await storage.read(key: 'jwt');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    current_user_id = prefs.getString("user_id");
    print('current_user_id:$current_user_id');

    if (filePath != null) {
      Uri apiUri =
          Uri.parse('$IP_URL/userReport/dashboard/$current_user_id/MakeReport');

      var request = http.MultipartRequest('POST', apiUri);
      request.headers['Authorization'] = 'Bearer $jwtToken';
      request.fields['report_description'] = description;
      request.fields['date_time'] =
          date.toLocal().toIso8601String().split(".")[0];
      request.fields['sub_location_id'] = sublocationId;
      request.fields['incident_subtype_id'] = incidentSubtypeId;
      request.fields['incident_criticality_id'] = criticalityId;

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        // imageFile.path,
        filePath,
      ));

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          print("response.statusCode: ${response.statusCode}");
          return 1;
        } else {
          throw Exception(
              'Failed to upload report with image, received status code: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Failed to upload report with image: $e');
      }
    } else {
      // return 2; //no image selected
      throw Exception('No image selected');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAdminActionReports() async {
    try {
      jwtToken = await storage.read(key: 'jwt');
      // jwtToken = 'k-sdkjnksddsd0';
      Uri url = Uri.parse('$IP_URL/admin/dashboard/fetchAllActionReports');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body) as List<dynamic>;
        // List<ActionReport> allReportList = jsonResponse
        //     .map((dynamic item) =>
        //         ActionReport.fromJson(item as Map<String, dynamic>))
        //     .toList();
        // return allReportList;

        final list =
            jsonResponse.map((e) => e as Map<String, dynamic>).toList();
        return list;
      } else {
        final responseBody = jsonDecode(response.body);
        final status = responseBody['message'];

        if (status.contains('Invalid token.') ||
            status.contains('Access denied')) {
          throw TokenExpiredException('Error: $status');
        } else {
          throw Exception('Error: $status');
        }
      }
    } catch (e) {
      if (e is TokenExpiredException) {
        // Preserve the TokenExpiredException and rethrow it
        throw e;
      } else {
        // Catch-all for other exceptions
        throw Exception('Failed to load Reports');
      }
    }
  }

  Future<int> postAssignedReport(int user_report_id, String user_id,
      String action_team_id, String incident_criticality_id) async {
    jwtToken = await storage.read(key: 'jwt');
    print(jwtToken);
    Uri url = Uri.parse('$IP_URL/admin/dashboard/InsertAssignTask');
    try {
      final http.Response response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $jwtToken'
        },
        body: jsonEncode(
          <String, dynamic>{
            "user_report_id": user_report_id,
            "user_id": user_id,
            "action_team_id": action_team_id,
            "incident_criticality_id": incident_criticality_id
          },
        ),
      );
      final msg = json.decode(response.body)['message'];

      if (response.statusCode == 200) {
        return 1;
      } else if (response.statusCode == 500) {
        return 0;
      } else if (response.statusCode == 403) {
        final responseBody = jsonDecode(response.body);
        final status = responseBody['message'];
        if (status == 'Invalid token.' ||
            status == 'Access denied. User role is not authorized.' ||
            status == 'Access denied, no token provided.') {
          Fluttertoast.showToast(msg: 'Session Timeout, Please login again');
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => LoginPage()),
          // );
          return 0;
        }
        return 0;
      } else if (msg == "Connection refused.") {
        Fluttertoast.showToast(msg: 'Connection Timeout: Check Internet');
        return 0;
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(msg: 'Report Already Assigned');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: '$e',
        toastLength: Toast.LENGTH_SHORT,
      );
      return 0;
    }
    return 0;
  }

  Future<int> uploadActionReport(ActionReportFormDetails details) async {
    debugPrint("uploading action report");
    String? jwtToken = await storage.read(key: 'jwt');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentUserId = prefs.getString("user_id");
    print('current_user_id:$currentUserId');

    Uri apiUri = Uri.parse(
        '$IP_URL/actionTeam/dashboard/$currentUserId/MakeActionReport');

    var request = http.MultipartRequest('POST', apiUri);
    request.headers['Authorization'] = 'Bearer $jwtToken';

    request.fields['report_description'] = details.incidentDesc;
    request.fields['question_one'] = details.rootCause1 ?? '';
    request.fields['question_two'] = details.rootCause2 ?? '';
    request.fields['question_three'] = details.rootCause3 ?? '';
    request.fields['question_four'] = details.rootCause4 ?? '';
    request.fields['question_five'] = details.rootCause5 ?? '';
    request.fields['resolution_description'] = details.resolutionDesc;
    request.fields['reported_by'] = details.reportedBy;
    request.fields['user_report_id'] = details.userReportId.toString();

    if (details.incidentSiteImgPath != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'surrounding_image', details.incidentSiteImgPath!));
    }

    request.files.add(await http.MultipartFile.fromPath(
        'proof_image', details.workProofImgPath));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Report submitted successfully');
        Fluttertoast.showToast(
            msg: "Action Report submitted successfully",
            toastLength: Toast.LENGTH_SHORT);
        return 1;
      } else {
        debugPrint("error message: ${await response.stream.bytesToString()}");
        Fluttertoast.showToast(
            msg: '${response.statusCode}', toastLength: Toast.LENGTH_SHORT);
        debugPrint(
            "failed to upload report, status code: ${response.statusCode}");
        throw Exception(
            "Failed to upload report, status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      throw Exception('Failed to upload report: $e');
    }
  }

  Future<int> uploadActionReportWithImagesFuture(
      String? report_description,
      String? question_one,
      String? question_two,
      String? question_three,
      String? question_four,
      String? question_five,
      String? resolution_description,
      String? reported_by,
      XFile? surrounding_image,
      XFile? proof_image,
      int? user_report_id) async {
    jwtToken = await storage.read(key: 'jwt');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? current_user_id = prefs.getString("user_id");
    print('current_user_id:$current_user_id');

    if (proof_image != null) {
      Uri apiUri = Uri.parse(
          '$IP_URL/actionTeam/dashboard/$current_user_id/MakeActionReport');

      var request = http.MultipartRequest('POST', apiUri);
      request.headers['Authorization'] = 'Bearer $jwtToken';

      request.fields['report_description'] = report_description!;
      request.fields['question_one'] = question_one!;
      request.fields['question_two'] = question_two!;
      request.fields['question_four'] = question_four!;
      request.fields['question_five'] = question_five!;
      request.fields["resolution_description"] = resolution_description!;
      request.fields["reported_by"] = reported_by!;
      request.fields["user_report_id"] = user_report_id.toString();

      if (surrounding_image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'surrounding_image',
          surrounding_image.path,
        ));
      }

      request.files.add(await http.MultipartFile.fromPath(
        'proof_image',
        proof_image.path,
      ));

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          print('Report submitted successfully');
          return 1;
        } else if (response.statusCode == 500) {
          Fluttertoast.showToast(
            msg: '${response.statusCode}',
            toastLength: Toast.LENGTH_SHORT,
          );
          return 0;
        } else {
          print('Failed to submit report');
          return 0;
        }
      } catch (e) {
        print('Error occurred: $e');
        return 0;
      }
    } else {
      print('One or both images are not selected');
      return 0;
    }
  }

  Future<int> postActionReport(
      String? report_description,
      String? question_one,
      String? question_two,
      String? question_three,
      String? question_four,
      String? question_five,
      String? resolution_description,
      String? reported_by,
      XFile? proof_image,
      int? user_report_id) async {
    jwtToken = await storage.read(key: 'jwt');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? current_user_id = prefs.getString("user_id");
    print('current_user_id:$current_user_id');

    if (proof_image != null) {
      Uri apiUri = Uri.parse(
          '$IP_URL/actionTeam/dashboard/$current_user_id/MakeActionReport');

      var request = http.MultipartRequest('POST', apiUri);
      request.headers['Authorization'] = 'Bearer $jwtToken';

      request.fields['report_description'] = report_description!;
      request.fields['question_one'] = question_one!;
      request.fields['question_two'] = question_two!;
      request.fields['question_four'] = question_four!;
      request.fields['question_five'] = question_five!;
      request.fields["resolution_description"] = resolution_description!;
      request.fields["reported_by"] = reported_by!;
      request.fields["user_report_id"] = user_report_id.toString();

      request.files.add(await http.MultipartFile.fromPath(
        'proof_image',
        proof_image.path,
      ));

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          print('Report submitted successfully');
          return 1;
        } else {
          debugPrint("error message: ${await response.stream.bytesToString()}");
          Fluttertoast.showToast(
            msg: '${response.statusCode}',
            toastLength: Toast.LENGTH_SHORT,
          );
          // return 0;
          throw Exception('Failed to submit report, status code: 500');
        }
      } catch (e) {
        print('Error occurred while sending action report: $e');
        throw Exception('Failed to submit report: $e');
        // return 0;
      }
    } else {
      print('proof image is not selected');
      throw Exception('No proof image selected');
      // return 0;
    }
  }

  //     String? report_description,
  //     String? question_one,
  //     String? question_two,
  //     String? question_three,
  //     String? question_four,
  //     String? question_five,
  //     String? resolution_description,
  //     String? reported_by,
  //     //XFile? surrounding_image,
  //     XFile? proof_image,
  //     int? user_report_id) async {
  //   jwtToken = await storage.read(key: 'jwt');

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   current_user_id = prefs.getString("user_id");
  //   Uri url = Uri.parse(
  //       '$IP_URL/actionTeam/dashboard/$current_user_id/MakeActionReport');
  //   try {
  //     final http.Response response = await http.post(
  //       url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         'Authorization': 'Bearer $jwtToken'
  //       },
  //       body: jsonEncode(
  //         <String, dynamic>{
  //           "report_description": report_description,
  //           "question_one": question_one,
  //           "question_two": question_two,
  //           "question_three": question_three,
  //           "question_four": question_four,
  //           "question_five": question_five,
  //           "resolution_description": resolution_description,
  //           "reported_by": reported_by,
  //           //"surrounding_image": null,
  //           "proof_image": proof_image,
  //           "user_report_id": user_report_id
  //         },
  //       ),
  //     );
  //     final msg = json.decode(response.body)['status'];

  //     if (response.statusCode == 200) {
  //       return 1;
  //     } else if (response.statusCode == 500) {
  //       Fluttertoast.showToast(
  //         msg: msg,
  //         toastLength: Toast.LENGTH_SHORT,
  //       );
  //       return 0;
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //       msg: '$e',
  //       toastLength: Toast.LENGTH_SHORT,
  //     );
  //     return 0;
  //   }
  //   return 0;
  // }

//Image handling
  Future<String?> uploadImage(File imageFile) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$IP_URL/api/image/upload'));

      // Adding the authorization header
      request.headers['Authorization'] = 'Bearer $jwtToken';

      // Attach the image file to the request
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));

      // Send the request
      var response = await request.send();

      // Process the response
      if (response.statusCode == 200) {
        print('Image uploaded successfully');

        // Assuming Cloudinary returns the image URL in the response
        final imageUrl = await response.stream.bytesToString();

        print('Image URL: $imageUrl');

        // Return the image URL
        return imageUrl;
      } else {
        print('Failed to upload image');
        return null;
      }
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }
  }
}
