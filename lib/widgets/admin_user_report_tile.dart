import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/admin_pages/asset_history_page.dart';
import 'package:safify/Admin%20Module/admin_pages/assign_form.dart';
import 'package:safify/Admin%20Module/providers/delete_user_report_provider.dart';
import 'package:safify/Admin%20Module/providers/admin_user_reports_provider.dart';
import 'package:safify/api/user_reports_service.dart';
import 'package:safify/components/custom_button.dart';
import 'package:safify/db/database_helper.dart';
import 'package:safify/models/user_report.dart';
import 'package:safify/services/toast_service.dart';
import 'package:safify/utils/button_utils.dart';
import 'package:safify/utils/string_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminUserReportTile extends StatelessWidget {
  final UserReport userReport;
  final UserReportsService _userReportsService = UserReportsService();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  AdminUserReportTile({super.key, required this.userReport});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Asset Name and Criticality Level
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 70,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssetHistoryPage(
                            assetNo: userReport.assetNo!,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      userReport.assetName ?? 'N/A',
                      style: const TextStyle(
                        color: Colors.black, // Subtle clickable color
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration
                            .underline, // Underline for clickable indication
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: userReport.incidentCriticalityLevel!.contains('low')
                        ? Colors.green[100]
                        : userReport.incidentCriticalityLevel!.contains('high')
                            ? Colors.orange[100]
                            : Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ' ${capitalizeFirstLetter(userReport.incidentCriticalityLevel)}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),

            // Divider between sections
            const Divider(thickness: 1, height: 20),

            // Status Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  userReport.status == 'open'
                      ? Icons.check_box_outline_blank_rounded
                      : userReport.status == 'in progress'
                          ? Icons.autorenew_outlined
                          : Icons.check_box_outlined,
                  color: userReport.status == 'open'
                      ? Colors.blue
                      : userReport.status == 'in progress'
                          ? Colors.orange
                          : Colors.green,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  ' ${capitalizeFirstLetter(userReport.status)}',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),

            // Divider
            const Divider(thickness: 1, height: 20),

            // Location Row
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: Colors.red, size: 22),
                const SizedBox(width: 8),
                Text(
                  userReport.subLocationName ?? 'N/A',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Date and Time
            Row(
              children: [
                const Icon(Icons.timer_outlined, color: Colors.blue, size: 22),
                const SizedBox(width: 8),
                Text(
                  '${userReport.dateTime?.split('T')[0]} | ${userReport.dateTime?.split('T')[1].replaceAll(RegExp(r'\.\d+Z$'), '')}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                // Text(
                //   DateUtils.timeAgoStr(userReport.dateTime!),
                //   style: const TextStyle(fontSize: 14, color: Colors.black54),
                // ),
              ],
            ),

            // Divider
            const Divider(thickness: 1, height: 20),

            // Report Description
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.textsms_outlined,
                    color: Colors.purple, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    userReport.reportDescription ?? 'No description provided',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons (Delete, Assign, View Image)
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Delete Button
                  if (userReport.status == 'open')
                    DeleteButton(
                      height: double.infinity,
                      onTap: () => handleDeleteButton(userReport, context),
                    ),

                  // Assign Button
                  if (userReport.status == 'open')
                    AssignButton(
                      height: double.infinity,
                      isAssigned: userReport.status!.isEmpty,
                      onTap: () => handleAssignTask(userReport, context),
                    ),

                  // View Image Button
                  ImageButton(
                    height: double.infinity,
                    onTap: () => handleImageButton(userReport.image, context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleDeleteButton(UserReport item, BuildContext context) {
    // Show a confirmation dialog before rejecting
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete?"),
          content: const Text("Are you sure you want to delete this report?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (!'${item.status}'.contains('in progress')) {
                  final success = await _userReportsService
                      .deleteUserReport('${item.userReportId}');

                  if (success) {
                    final dbDeleteResult = await _databaseHelper
                        .deleteAdminUserReport(item.userReportId!);
                    if (dbDeleteResult) {
                      final provResult =
                          await Provider.of<AdminUserReportsProvider>(context,
                                  listen: false)
                              .fetchAdminUserReportsFromDb(context);
                    }
                  }

                  Navigator.of(context).pop(); // Close the dialog
                  ToastService.showDeletedReportSnackBar(context, success);
                } else {}
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void handleAssignTask(UserReport item, BuildContext context) async {
    //Add to Assigned form
    //  Fluttertoast.showToast(msg: '${item.id}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //                                        if (item != null && item.user_id != null) {
    if (item.userId != null) {
      await prefs.setString("this_user_id", (item.userId!));
    }
    if (item.userReportId != null) {
      await prefs.setInt("user_report_id", (item.userReportId!));
    }

    //                          if(prefs.getString('user_id') !=null && prefs.getInt('user_report_id') !=null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AssignForm()),
    );
    //                           }
    // print('user_id: ${prefs.getString('this_user_id')}');
    // print('id: ${item.id}');
  }
}
