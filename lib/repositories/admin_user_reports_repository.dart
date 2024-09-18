import 'package:flutter/material.dart';
import 'package:safify/db/database_helper.dart';
import 'package:safify/models/user_report.dart';
import 'package:safify/services/report_service.dart';

class AdminUserReportsRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final ReportServices _reportServices = ReportServices();

  Future<List<UserReport>> fetchAdminUserReportsFromDb() async {
    final reportsJsonList = await _databaseHelper.getAdminUserReports();
    // debugPrint("admin user reports: $reportsJsonList");
    return reportsJsonList
        .map<UserReport>((json) => UserReport.fromJson(json))
        .toList();
  }

  /// need to shift to separate isolate with workmanager
  Future<void> syncDb() async {
    try {
      final jsonList = await _reportServices.fetchAdminUserReports();
      await _databaseHelper.insertAdminUserReportsJson(jsonList);
    } catch (e) {
      debugPrint("Error syncing database: $e");
      rethrow;
    }

    // print('AssignTasks from DB: $list');
  }
}
