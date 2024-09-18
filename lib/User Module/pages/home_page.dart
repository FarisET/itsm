// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/User%20Module/pages/login_page.dart';
import 'package:safify/User%20Module/pages/user_form.dart';
import 'package:safify/User%20Module/providers/user_reports_provider.dart';
import 'package:safify/db/database_helper.dart';
import 'package:safify/models/user_report_form_details.dart';
import 'package:safify/repositories/incident_types_repository.dart';
import 'package:safify/repositories/location_repository.dart';
import 'package:safify/services/report_service.dart';
import 'package:safify/services/UserServices.dart';
import 'package:safify/services/toast_service.dart';
import 'package:safify/utils/network_util.dart';
import 'package:safify/widgets/user_actions_modal_sheet.dart';
import 'package:safify/widgets/user_report_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  // padding constants
  final double mainHeaderSize = 18;

  String? user_name;
  String? user_id;
  UserServices userServices = UserServices();

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  void updateUI() {
    setState(() {});
  }

  void getUsername() {
    SharedPreferences.getInstance().then((prefs) async {
      user_name = await userServices.getName();
      setState(() {
        user_id = prefs.getString("user_id");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/safify_icon.png'),
          ),
          title: Text("Home",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: mainHeaderSize,
                color: Theme.of(context).secondaryHeaderColor,
              )),
          actions: [
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  // Show a confirmation dialog before logging out
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content:
                            const Text('Are you sure you want to log out?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(dialogContext)
                                  .pop(); // Close the dialog
                            },
                          ),
                          TextButton(
                            child: const Text('Logout'),
                            onPressed: () async {
                              Navigator.of(dialogContext)
                                  .pop(); // Close the dialog
                              // Perform logout actions here
                              bool res = await handleLogout(context);
                              if (res == true) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    content: const Text('Logout Failed'),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                color: Theme.of(context).secondaryHeaderColor),
          ]),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              // backgroundColor: const Color(0xff1593f8),
              backgroundColor: Colors.black,
              //  backgroundColor: Colors.white,
              onPressed: () {
                LocationRepository().syncDbLocationsAndSublocations();
                IncidentTypesRepository().syncDbIncidentAndSubincidentTypes();
                _showBottomSheet();
              },
              child: const Icon(
                Icons.add,
              ),
            ),

            // const SizedBox(
            //   height: 10,
            // ),
            // FloatingActionButton(
            //   child: const Icon(Icons.notifications),
            //   onPressed: () async {
            //     Future.delayed(const Duration(seconds: 0), () {
            //       NotifTestService.testNotif();
            //     });
            //     // NotifTestService.testNotif();
            //   },
            // )
            // const SizedBox(
            //   height: 10,
            // ),
            // FloatingActionButton(
            //   backgroundColor: Colors.blue,
            //   onPressed: () async {
            //     print("hi");
            //     final dbhelper = DatabaseHelper();

            //     // final lists = parseLocationsAndSubLocations(locationsJson);
            //     // await dbhelper.insertLocationsAndSublocations(
            //     //     lists[0] as List<Location>,
            //     //     lists[1] as List<SubLocation>);
            //     // final locations = await dbhelper.getLocations();
            //     // final sublocations = await dbhelper.getAllSubLocations();
            //     // print("count of locations: ${locations.length}");
            //     // print("count of sublocations: ${sublocations.length}");

            //     // print('Locations:');
            //     // for (var location in locations) {
            //     //   print(location);
            //     // }

            //     // print('\nSub Locations:');
            //     // for (var subLocation in sublocations) {
            //     //   print(subLocation);
            //     // }

            //     final userFormReports = await dbhelper.getUserFormReports();
            //     print('User Form Reports:');
            //     for (var report in userFormReports.values) {
            //       print(report);
            //     }

            //     // await uploadUserFormReports(context);

            //     final userFormReports2 = await dbhelper.getUserFormReports();
            //     print('User Form Reports:');
            //     for (var report in userFormReports2.values) {
            //       print(report);
            //     }
            //   },
            //   child: const Icon(
            //     CupertinoIcons.pencil_ellipsis_rectangle,
            //     color: Colors.white,
            //   ),
            // ),
            // const SizedBox(height: 10),
            // FloatingActionButton(
            //   //  backgroundColor: Colors.white,
            //   onPressed: () {
            //     // FlutterBackgroundService().startService();
            //     // FlutterBackgroundService().invoke('stopService');
            //     "pressed suitcase button";
            //     // BackgroundTaskManager().registerAnotherTask();
            //     // BackgroundTaskManager().cancelTask("1");
            //     // BackgroundTaskManager().registerPeriodicTasks();
            //     // ping_google();
            //   },
            //   child: const Icon(
            //     Icons.work,
            //   ),
            // )
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.05,
              vertical: MediaQuery.sizeOf(context).height * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              //    welcome home
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO: get user name dynamically in welcome
                      user_name != null
                          ? Text(
                              '$user_name',
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            )
                          : const Text(
                              'User',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.007,
                      ),
                      Text(intl.DateFormat('d MMMM y').format(DateTime.now()),
                          style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                ],
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              const Divider(
                thickness: 1,
                color: Color.fromARGB(255, 204, 204, 204),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              // previous reports
              const Text(
                "My Reports",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.009,
              ),

              // list of reports
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.60,
                child: RefreshIndicator(
                    onRefresh: () async {
                      updateUI();
                      final result = await Provider.of<UserReportsProvider>(
                              context,
                              listen: false)
                          .fetchReports(context);
                      if (result.contains("success")) {
                        // ToastService.showUpdatedLocalDbSuccess(context);
                      } else {
                        ToastService.showFailedToFetchReportsFromServer(
                            context);
                      }
                    },
                    child: const UserReportList()),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> uploadUserFormReports(BuildContext context) async {
    print("uploading reports...");
    final pingSuccess = await ping_google();
    if (!pingSuccess) {
      print("Connection error. Retrying later...");
      return;
    }
    final dbHelper = await DatabaseHelper();
    final Map<int, UserReportFormDetails> reports =
        await dbHelper.getUserFormReports();
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

  void _showBottomSheet() {
    showModalBottomSheet(
        isDismissible: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return SizedBox(
            height: MediaQuery.sizeOf(context).height * .4,
            child: const UserActionsModalSheet(),
          );
        });
  }
}

Future<bool> handleLogout(BuildContext context) async {
  UserServices userServices = UserServices();
  bool res = await userServices.logout();
  if (res == true) {
    return true;
  } else {
    return false;
  }
}
