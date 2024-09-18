import 'package:flutter/material.dart';
import 'package:safify/db/database_helper.dart';
import 'package:safify/models/action_report.dart';
import 'package:safify/services/report_service.dart';

class AdminActionReportsRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final ReportServices _reportServices = ReportServices();

  Future<List<ActionReport>> fetchAdminActionReportsFromDb() async {
    final reportsJsonList = await _databaseHelper.getAdminActionReports();
    return reportsJsonList
        .map<ActionReport>((json) => ActionReport.fromJson(json))
        .toList();
  }

  /// need to shift to separate isolate with workmanager
  Future<void> syncDb() async {
    try {
      final jsonList = await _reportServices.fetchAdminActionReports();
      await _databaseHelper.insertAdminActionReportsJson(jsonList);
    } catch (e) {
      debugPrint("Error syncing database: $e");
      rethrow;
    }

    // print('AssignTasks from DB: $list');
  }
}
