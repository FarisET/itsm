import 'package:flutter/material.dart';
import 'package:safify/db/database_helper.dart';
import 'package:safify/models/user_report.dart';
import 'package:safify/services/report_service.dart';

class UserReportsRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final ReportServices _reportServices = ReportServices();

  Future<List<UserReport>> fetchUserReportsFromDb() async {
    final reportsJsonList = await _databaseHelper.getUserReports();
    // debugPrint("admin user reports: $reportsJsonList");
    return reportsJsonList
        .map<UserReport>((json) => UserReport.fromJson(json))
        .toList();
  }

  /// need to shift to separate isolate with workmanager
  Future<void> syncDb() async {
    try {
      final jsonList = await _reportServices.fetchUserReports();
      await _databaseHelper.insertUserReportsJson(jsonList);
    } catch (e) {
      debugPrint("Error syncing database: $e");
      rethrow;
    }

    // print('AssignTasks from DB: $list');
  }
}
