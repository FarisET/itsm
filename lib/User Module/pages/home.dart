import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/user_report_list.dart';
import '../../services/UserServices.dart';
import 'login_page.dart';
import 'user_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? user_name;
  String? user_id;
  UserServices userServices = UserServices();

  @override
  void initState() {
    super.initState();
    getUsername();
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
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.6;

    return PopScope(
      onPopInvoked: (didPop) {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: const Text('Are you sure you want to log out?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Close the dialog
                  },
                ),
                TextButton(
                  child: const Text('Logout'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Close the dialog
                    // Perform logout actions here
                    handleLogout(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Safify',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto'),
          ),
          actions: [
            SizedBox(
              height: 100,
              child: FilledButton(
                child: const Text(
                  'Close App',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto'),
                ),
                onPressed: () {
                  // Show a confirmation dialog before logging out
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content: const Text(
                            'Are you sure you want to close the app?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(dialogContext)
                                  .pop(); // Close the dialog
                            },
                          ),
                          TextButton(
                            child: const Text('Close'),
                            onPressed: () {
                              Navigator.of(dialogContext)
                                  .pop(); // Close the dialog

                              // Close the app
                              if (Platform.isAndroid) {
                                SystemNavigator.pop(); // For Android devices
                              } else if (Platform.isIOS) {
                                exit(0); // For iOS devices (use with caution)
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Wrap(
                        direction: Axis.horizontal,
                        //Text
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            child: Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Hi,$user_name!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    intl.DateFormat.yMd()
                                        .format(DateTime.now()),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //Profile
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: Colors.grey[300],
                          //     borderRadius: BorderRadius.circular(12),
                          //   ),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(12.0),
                          //     child: Icon(Icons.person),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.blue[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserForm()),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Report an Incident',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              //Previous reports

              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: containerHeight,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Previous Reports',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: UserReportList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleLogout(BuildContext context) async {
    UserServices userServices = UserServices();
    await userServices.logout();
  }
}
