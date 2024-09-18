import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safify/db/database_helper.dart';
import 'package:safify/models/assign_task.dart';
import 'package:safify/services/report_service.dart';
import 'package:safify/utils/network_util.dart';

class AssignTasksRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final ReportServices _reportServices = ReportServices();
  final storage = const FlutterSecureStorage();

  Future<List<AssignTask>> fetchAssignTasksFromDb() async {
    return await _databaseHelper.getAllAssignTasks();
  }

  /// need to shift to separate isolate with workmanager
  Future<void> syncDb() async {
    try {
      final jsonList = await _reportServices.fetchAssignedReports();
      await _databaseHelper.insertAssignTasksJson(jsonList);
    } catch (e) {
      debugPrint("Error syncing database: $e");
      rethrow;
    }

    // print('AssignTasks from DB: $list');
  }
}
