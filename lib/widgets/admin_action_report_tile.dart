import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:safify/Action%20Team%20Module/providers/action_reports_provider.dart';
import 'package:safify/Action%20Team%20Module/providers/all_action_reports_approveal_provider.dart';
import 'package:safify/Admin%20Module/providers/action_team_provider.dart';
import 'package:safify/Admin%20Module/providers/delete_action_report_provider.dart';
import 'package:safify/components/custom_button.dart';
import 'package:safify/db/database_helper.dart';
import 'package:safify/models/action_report.dart';
import 'package:safify/services/action_reports_service.dart';
import 'package:safify/services/report_service.dart';
import 'package:safify/services/toast_service.dart';
import 'package:safify/utils/button_utils.dart';
import 'package:safify/widgets/admin_action_reports_list.dart';

class AdminActionReportTile extends StatelessWidget {
  final ActionReport actionReport;

  const AdminActionReportTile({super.key, required this.actionReport});

  @override
  Widget build(BuildContext context) {
    final approvalStatusProvider = Provider.of<ApprovalStatusProvider>(context);
    final fetchAllRepsProvider =
        Provider.of<ActionReportsProvider>(context, listen: false);
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensure column size is constrained
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Incident Type and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    actionReport.incident_subtype_description ?? 'N/A',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined,
                        color: Colors.blue, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      actionReport.date_time != null
                          ? '${actionReport.date_time!.split('T')[0]} | ${actionReport.date_time!.split('T')[1].replaceAll(RegExp(r'\.\d+Z$'), '')}'
                          : 'No Date',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(thickness: 1, height: 1),

            // Reported By Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  const Icon(Icons.person_outline,
                      color: Colors.orange, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    actionReport.reported_by ?? 'Unknown Reporter',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1, height: 1),

            // Report Description
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.textsms_outlined,
                      color: Colors.purple, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      actionReport.report_description!.isNotEmpty
                          ? actionReport.report_description!
                          : 'No description provided',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1, height: 1),

            // Resolution Description
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline_rounded,
                      color: Colors.green, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      actionReport.resolution_description?.isNotEmpty ?? false
                          ? actionReport.resolution_description!
                          : 'No resolution provided',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons (Image, Approve, Reject)
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImageButton(
                    height: double.infinity,
                    onTap: () {
                      handleImageButton(actionReport.proof_image, context);
                    },
                  ),
                  ApproveButton(
                    height: double.infinity,
                    isApproved:
                        actionReport.status?.contains('approved') ?? false,
                    onTap: () async {
                      await showApproveConfirmDialog(context);
                    },
                  ),
                  Visibility(
                    visible: actionReport.status != 'approved',
                    child: RejectButton(
                      onTap: () {
                        showRejectConfirmDialogue(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showApproveConfirmDialog(BuildContext context) {
    final fetchAllRepsProvider =
        Provider.of<ActionReportsProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Approve?"),
          content: const Text("Are you sure you want to approve this report?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (actionReport.action_report_id != null &&
                    actionReport.user_report_id != null) {
                  final success = await ReportServices()
                      .postapprovedActionReport(actionReport.user_report_id,
                          actionReport.action_report_id);

                  if (success) {
                    fetchAllRepsProvider.fetchAllActionReports(context);
                  } else {
                    debugPrint("Failed to approve report");
                  }
                  ToastService.showReportApprovedSnackBar(context, success);
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> showRejectConfirmDialogue(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reject?"),
          content: const Text(
              "Are you sure you want to reject this report? This will delete the report."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final actionReportsService = ActionReportsService();
                final result = await actionReportsService
                    .deleteActionReport(actionReport.action_report_id!);

                if (result) {
                  final dbResult = await DatabaseHelper()
                      .deleteAdminActionReport(actionReport.action_report_id!);
                  if (dbResult) {
                    final provResult = await Provider.of<ActionReportsProvider>(
                            context,
                            listen: false)
                        .fetchAllActionReportsFromDb(context);
                  }
                }
                Navigator.of(context).pop(); // Close the dialog

                ToastService.showRejectedReportSnackBar(context, result);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}
