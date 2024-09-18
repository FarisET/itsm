import 'package:flutter/material.dart';
import 'package:safify/db/database_helper.dart';
import 'package:safify/models/action_report.dart';
import 'package:safify/repositories/admin_action_reports_repository.dart';
import 'package:safify/services/toast_service.dart';
import 'package:safify/utils/network_util.dart';

class ActionReportsProvider with ChangeNotifier {
  List<ActionReport>? _reports;
  List<ActionReport>? get reports => _reports;
  bool isLoading = false;
  String? _error;
  String? get error => _error;
  final AdminActionReportsRepository _actionReportRepository =
      AdminActionReportsRepository();

  Future<void> refresh(BuildContext context) {
    return fetchAllActionReports(context);
  }

  Future<String> fetchAllActionReports(BuildContext context) async {
    try {
      _error = null;
      isLoading = true;
      // await DatabaseHelper().clearTable("admin_action_reports");
      final reports =
          await _actionReportRepository.fetchAdminActionReportsFromDb();
      _reports = reports;
      isLoading = false;

      notifyListeners();
      debugPrint("Fetched admin action reports from local database.");

      final ping = await ping_google();

      if (ping) {
        // ToastService.showSyncingLocalDataSnackBar(context);
        await _actionReportRepository.syncDb();
        _reports =
            await _actionReportRepository.fetchAdminActionReportsFromDb();
        isLoading = false;
        notifyListeners();
        debugPrint("Fetched admin action user reports from API.");
        return "successfully fetched admin action reports from API";
      } else {
        // ToastService.showCouldNotConnectSnackBar(context);
        debugPrint(
            "No internet connection, could not fetch admin action reports from API.");
        return "failed to fetch admin action reports from API.";
      }
    } catch (e) {
      _error = e.toString();
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<String> fetchAllActionReportsFromDb(BuildContext context) async {
    try {
      _error = null;
      isLoading = true;
      final reports =
          await _actionReportRepository.fetchAdminActionReportsFromDb();
      _reports = reports;
      isLoading = false;

      notifyListeners();
      debugPrint("Fetched admin action reports from local database.");
      return "successfully fetched admin action reports from local database.";
    } catch (e) {
      _error = e.toString();
      isLoading = false;
      notifyListeners();
      return "failed to fetch admin action reports from local database.";

      // rethrow;
    }
  }

  // Future<void> fetchAllActionReports(BuildContext context) async {
  //   try {
  //     _error = null;
  //     isLoading = true;
  //     _reports = await ReportServices().fetchAdminActionReports();
  //     isLoading = false;
  //     notifyListeners();
  //   } catch (e) {
  //     _error = e.toString();
  //     isLoading = false;
  //     notifyListeners();
  //     rethrow;
  //   }
  // }
}
