import 'package:image_picker/image_picker.dart';
import 'package:safify/db/database_helper.dart';
import 'package:safify/models/action_report_form_details.dart';
import 'package:safify/models/user_report_form_details.dart';
import 'package:safify/services/report_service.dart';
import 'package:safify/utils/network_util.dart';

class ReportUploadService {
  static Future<void> uploadUserFormReports() async {
    print("uploading reports...");
    final pingSuccess = await ping_google();
    if (!pingSuccess) {
      print("Backend is unreachable. Retrying later...");
      return;
    }
    final dbHelper = await DatabaseHelper();

    final Map<int, UserReportFormDetails> reports =
        await dbHelper.getUserFormReports();

    if (reports.isEmpty) {
      print("No reports to upload");
      return;
    }

    final reportService = ReportServices();

    for (var entry in reports.entries) {
      int id = entry.key;
      UserReportFormDetails report = entry.value;
      int uploadSuccess = -1;
      try {
        if (report.imagePath != null) {
          uploadSuccess = await reportService.uploadReportWithImage(
              report.imagePath,
              report.sublocationId,
              report.incidentSubtypeId,
              report.description,
              report.date,
              report.criticalityId);
        } else {
          uploadSuccess = await reportService.postReport(
              report.sublocationId,
              report.incidentSubtypeId,
              report.description,
              report.date,
              report.criticalityId);
        }
      } catch (e) {
        rethrow;
      }

      if (uploadSuccess == 1) {
        await dbHelper.deleteUserFormReport(id);
        print("Report successfully sent and deleted from local database");
      } else {
        print("Report failed to send. Retrying later...: error:$uploadSuccess");
      }
    }
  }

  static Future<void> uploadActionReportForms() async {
    print("uploading action reports...");
    final pingSuccess = await ping_google();
    if (!pingSuccess) {
      print("Backend is unreachable. Retrying later...");
      return;
    }
    final dbHelper = await DatabaseHelper();

    final Map<int, ActionReportFormDetails> reports =
        await dbHelper.getActionFormReports();

    if (reports.isEmpty) {
      print("No reports to upload");
      return;
    }

    final reportService = ReportServices();
    for (var entry in reports.entries) {
      int id = entry.key;
      ActionReportFormDetails report = entry.value;
      int uploadSuccess = -1;
      try {
        if (report.incidentSiteImgPath != null) {
          uploadSuccess =
              await reportService.uploadActionReportWithImagesFuture(
            report.incidentDesc,
            report.rootCause1,
            report.rootCause2,
            report.rootCause3,
            report.rootCause4,
            report.rootCause5,
            report.resolutionDesc,
            report.reportedBy,
            XFile(report.incidentSiteImgPath!),
            XFile(report.workProofImgPath),
            report.userReportId,
          );
        } else {
          uploadSuccess = await reportService.postActionReport(
            report.incidentDesc,
            report.rootCause1,
            report.rootCause2,
            report.rootCause3,
            report.rootCause4,
            report.rootCause5,
            report.resolutionDesc,
            report.reportedBy,
            XFile(report.workProofImgPath),
            report.userReportId,
          );
        }
      } catch (e) {
        rethrow;
      }

      if (uploadSuccess == 1) {
        await dbHelper.deleteActionFormReport(id);
        print("Report successfully sent and deleted from local database");
      } else {
        print("Report failed to send. Retrying later...: error:$uploadSuccess");
      }
    }
  }
}
