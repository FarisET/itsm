import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 70,
                            child: Text(
                              userReport.incidentSubtypeDescription!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 30,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                  '${capitalizeFirstLetter(userReport.incidentCriticalityLevel)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: userReport
                                              .incidentCriticalityLevel!
                                              .contains('minor')
                                          ? Colors.black
                                          : (userReport
                                                  .incidentCriticalityLevel!
                                                  .contains('serious')
                                              ? Colors.black
                                              : Colors.black),
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        '${userReport.status}'.contains('open')
                            ? const Icon(Icons.check_box_outline_blank_rounded,
                                color: Colors.black, size: 20)
                            : '${userReport.status}'.contains('in progress')
                                ? const Icon(Icons.autorenew_outlined,
                                    color: Colors.black, size: 20)
                                : const Icon(Icons.check_box_outlined,
                                    color: Colors.black, size: 20),
                        Text(' ${capitalizeFirstLetter(userReport.status)}')
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.005,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: Colors.black, size: 20),
                        Text(' ${userReport.subLocationName}')
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.005,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined,
                            color: Colors.black, size: 20),
                        Text(
                            ' ${userReport.dateTime?.split('T')[0]} | ${userReport.dateTime?.split('T')[1].replaceAll(RegExp(r'\.\d+Z$'), '')}')
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.005,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.textsms_outlined,
                            color: Colors.black, size: 20),
                        Expanded(
                          child: Text(
                            ' ${userReport.reportDescription}',
                            style: const TextStyle(
                                //  fontSize: 16
                                ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment:
                            MediaQuery.of(context).size.width < 360
                                ? MainAxisAlignment.spaceEvenly
                                : MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: (userReport.status == 'open'),
                            child: DeleteButton(
                                height: double.infinity,
                                onTap: () =>
                                    handleDeleteButton(userReport, context)),
                          ),
                          Visibility(
                            visible: (userReport.status == 'open'),
                            child: AssignButton(
                              height: double.infinity,
                              isAssigned: userReport.status!.isEmpty,
                              onTap: () =>
                                  handleAssignTask(userReport, context),
                            ),
                          ),
                          ImageButton(
                            height: double.infinity,
                            onTap: () =>
                                handleImageButton(userReport.image, context),
                          )
                        ],
                      ),
                    ),
                  ]),
            ],
          ),
        ));
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
