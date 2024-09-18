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
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            actionReport.incident_subtype_description!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all()),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person_outline,
                              color: Colors.black, size: 20),
                          Flexible(
                            child: Text(
                              ' ${actionReport.reported_by}',
                              style: const TextStyle(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.timer_outlined,
                            color: Colors.black, size: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                              '${actionReport.date_time?.split('T')[0]} | ${actionReport.date_time?.split('T')[1].replaceAll(RegExp(r'\.\d+Z$'), '')}'),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.textsms_outlined,
                            color: Colors.black, size: 20),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              //    item.report_description!.isNotEmpty ?
                              actionReport.report_description!.isNotEmpty
                                  ? actionReport.report_description!
                                  : '-',
                              style: const TextStyle(),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.note_alt_outlined,
                            color: Colors.black, size: 20),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '${actionReport.resolution_description}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.04,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ImageButton(
                              height: double.infinity,
                              onTap: () {
                                handleImageButton(
                                    actionReport.proof_image, context);
                              }),
                          ApproveButton(
                              height: double.infinity,
                              isApproved:
                                  actionReport.status!.contains('approved'),
                              onTap: () async {
                                await showApproveConfirmDialog(context);
                              }),
                          Visibility(
                              visible: actionReport.status != 'approved',
                              child: RejectButton(
                                onTap: () {
                                  showRejectConfirmDialogue(context);
                                },
                              ))
                        ],
                      ),
                    ),
                  ]),
            ],
          ),
        ));
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
