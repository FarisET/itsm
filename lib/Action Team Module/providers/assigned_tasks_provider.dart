import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safify/models/assign_task.dart';
import 'package:safify/repositories/assign_tasks_repository.dart';
import 'package:safify/services/toast_service.dart';
import 'package:safify/utils/network_util.dart';

class AssignedTasksProvider with ChangeNotifier {
  final _assignTasksRepository = AssignTasksRepository();
  List<AssignTask>? _tasks;
  List<AssignTask>? get tasks => _tasks;
  bool isLoading = true;
  String? _error;
  String? get error => _error;

  set error(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<String> fetchAssignedTasks(BuildContext context) async {
    try {
      _error = null;
      isLoading = true;
      _tasks = await _assignTasksRepository.fetchAssignTasksFromDb();
      isLoading = false;

      notifyListeners();
      debugPrint("Fetched assigned tasks from local database.");

      final ping = await ping_google();
      if (ping) {
        // ToastService.showSyncingLocalDataSnackBar(context);
        await _assignTasksRepository.syncDb();
        _tasks = await _assignTasksRepository.fetchAssignTasksFromDb();
        isLoading = false;
        notifyListeners();
        debugPrint("Fetched assigned tasks from API.");
        return "successfully fetched assigned tasks from API";
      } else {
        // ToastService.showCouldNotConnectSnackBar(context);
        debugPrint(
            "No internet connection, could not fetch assigned tasks from API.");
        return "failed to fetch assigned tasks from API.";
      }
    } catch (e) {
      _error = e.toString();
      isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
