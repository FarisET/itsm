import 'dart:async';
import 'package:safify/services/report_upload_service.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundTaskManager {
  // Private constructor
  BackgroundTaskManager._privateConstructor();

  // Static instance
  static final BackgroundTaskManager _instance =
      BackgroundTaskManager._privateConstructor();

  // Factory constructor to return the same instance
  factory BackgroundTaskManager() {
    return _instance;
  }

  void cancelTask(String uniqueTaskName) async {
    Workmanager().cancelByUniqueName(uniqueTaskName).then((value) {
      print("Task $uniqueTaskName cancelled");
    });
  }

  Future<void> initializeWorkManager() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  void registerSyncUserFormTask() {
    Workmanager().registerPeriodicTask(
      "1",
      "syncUserFormReports",
      frequency: const Duration(minutes: 15),
    );
  }

  void registerAnotherTask() {
    Workmanager().registerOneOffTask(
      "2",
      "anotherTask",
    );
  }

  void registerSyncActionFormTask() {
    Workmanager().registerPeriodicTask(
      "3",
      "syncActionFormReports",
      frequency: const Duration(minutes: 15),
    );
  }

  // task to check last user id and clear db
  void registerCheckLastUserIdTask() {
    Workmanager().registerOneOffTask(
      "4",
      "checkLastUserId",
    );
  }

  // task to get locations
  void registerGetLocationsTask() {
    Workmanager().registerOneOffTask(
      "4",
      "getLocations",
    );
  }

  // task to get incident types
  void registerGetIncidentTypesTask() {
    Workmanager().registerOneOffTask(
      "5",
      "getIncidentTypes",
    );
  }

  // task to get user reports
  void registerGetUserReportsTask() {
    Workmanager().registerOneOffTask(
      "6",
      "getUserReports",
    );
  }

  // task to get action reports
  void registerGetActionReportsTask() {
    Workmanager().registerOneOffTask(
      "7",
      "getActionReports",
    );
  }

  // task to get admin user reports
  void registerGetAdminUserReportsTask() {
    Workmanager().registerOneOffTask(
      "8",
      "getAdminUserReports",
    );
  }

  // task to get admin action reports
  void registerGetAdminActionReportsTask() {
    Workmanager().registerOneOffTask(
      "9",
      "getAdminActionReports",
    );
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputDataMap) async {
    switch (taskName) {
      case "syncUserFormReports":
        print("Executing syncUserFormReports task...");
        await ReportUploadService.uploadUserFormReports();
        break;
      case "anotherTask":
        print("Executing anotherTask...");
        await anotherTask();
        break;
      case "syncActionFormReports":
        print("Executing syncActionFormReports task...");
        await ReportUploadService.uploadActionReportForms();
        break;
      default:
        print("Unknown task: $taskName");
    }
    return Future.value(true);
  });
}

Future<void> anotherTask() async {
  print("doing something random...");
}

// Future<void> uploadUserFormReports() async {
//   print("uploading reports...");
//   final pingSuccess = await ping_google();
//   if (!pingSuccess) {
//     print("Backend is unreachable. Retrying later...");
//     return;
//   }
//   final dbHelper = await DatabaseHelper();

//   final Map<int, UserReportFormDetails> reports =
//       await dbHelper.getUserFormReports();

//   if (reports.isEmpty) {
//     print("No reports to upload");
//     return;
//   }

//   final reportService = ReportServices();

//   for (var entry in reports.entries) {
//     int id = entry.key;
//     UserReportFormDetails report = entry.value;
//     int uploadSuccess = -1;
//     try {
//       if (report.imagePath != null) {
//         uploadSuccess = await reportService.uploadReportWithImage(
//             report.imagePath,
//             report.sublocationId,
//             report.incidentSubtypeId,
//             report.description,
//             report.date,
//             report.criticalityId);
//       } else {
//         uploadSuccess = await reportService.postReport(
//             report.sublocationId,
//             report.incidentSubtypeId,
//             report.description,
//             report.date,
//             report.criticalityId);
//       }
//     } catch (e) {
//       rethrow;
//     }

//     if (uploadSuccess == 1) {
//       await dbHelper.deleteUserFormReport(id);
//       print("Report successfully sent and deleted from local database");
//     } else {
//       print("Report failed to send. Retrying later...: error:$uploadSuccess");
//     }
//   }
// }

// Future<void> uploadActionReportForms() async {
//   print("uploading action reports...");
//   final pingSuccess = await ping_google();
//   if (!pingSuccess) {
//     print("Backend is unreachable. Retrying later...");
//     return;
//   }
//   final dbHelper = await DatabaseHelper();

//   final Map<int, ActionReportFormDetails> reports =
//       await dbHelper.getActionFormReports();

//   if (reports.isEmpty) {
//     print("No reports to upload");
//     return;
//   }

//   final reportService = ReportServices();
//   for (var entry in reports.entries) {
//     int id = entry.key;
//     ActionReportFormDetails report = entry.value;
//     int uploadSuccess = -1;
//     try {
//       if (report.incidentSiteImgPath != null) {
//         uploadSuccess = await reportService.uploadActionReportWithImagesFuture(
//           report.incidentDesc,
//           report.rootCause1,
//           report.rootCause2,
//           report.rootCause3,
//           report.rootCause4,
//           report.rootCause5,
//           report.resolutionDesc,
//           report.reportedBy,
//           XFile(report.incidentSiteImgPath!),
//           XFile(report.workProofImgPath),
//           report.userReportId,
//         );
//       } else {
//         uploadSuccess = await reportService.postActionReport(
//           report.incidentDesc,
//           report.rootCause1,
//           report.rootCause2,
//           report.rootCause3,
//           report.rootCause4,
//           report.rootCause5,
//           report.resolutionDesc,
//           report.reportedBy,
//           XFile(report.workProofImgPath),
//           report.userReportId,
//         );
//       }
//     } catch (e) {
//       rethrow;
//     }

//     if (uploadSuccess == 1) {
//       await dbHelper.deleteActionFormReport(id);
//       print("Report successfully sent and deleted from local database");
//     } else {
//       print("Report failed to send. Retrying later...: error:$uploadSuccess");
//     }
//   }
// }
