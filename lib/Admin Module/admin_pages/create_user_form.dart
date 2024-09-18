import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:safify/services/UserServices.dart';
import 'package:safify/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../services/report_service.dart';
import '../../models/action_team.dart';
import '../../models/department.dart';
import '../../widgets/build_dropdown_menu_util.dart';
import '../providers/action_team_provider.dart';
import '../providers/department_provider.dart';
import 'admin_home_page.dart';

class CreatUserForm extends StatefulWidget {
  const CreatUserForm({super.key, Key});

  @override
  State<CreatUserForm> createState() => _CreatUserFormState();
}

class _CreatUserFormState extends State<CreatUserForm> {
  final _formKey = GlobalKey<FormState>();
  int selectedChipIndex = -1;
  List<bool> isSelected = [false, false, false];
  List<String> chipLabels = ['User', 'Action Team', 'Admin'];
  List<String> chipLabelsid = ['user', 'action_team', 'admin'];
  String userID = '';
  String password = '';
  String confirmPassword = '';

  final TextEditingController _idFieldController = TextEditingController();
  final TextEditingController _passFieldController = TextEditingController();
  final TextEditingController _confpassFieldController =
      TextEditingController();

  //List<String> dropdownMenuEntries = [];
  String? user_id;
  bool _confirmedExit = false;
  bool isRoleSelected = false;
  void _processData() {
    // Process your data and upload to the server
    _formKey.currentState?.reset();
  }

  Color? _getSelectedColor(int index) {
    if (isSelected[index]) {
      if (index == 0) {
        return Colors.greenAccent;
      } else if (index == 1) {
        return Colors.orangeAccent;
      } else if (index == 2) {
        return Colors.redAccent;
      }
    }
    return null;
  }

  int id = 0; // auto-generated
  DateTime date = DateTime.now();
  bool status =
      false; // how to update, initially false, will be changed by admin.
  String selected_role_id = '';
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_confirmedExit) {
          // If the exit is confirmed, replace the current route with the home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminHomePage()),
          );
          return false; // Prevent the user from going back
        } else {
          // Show the confirmation dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Exit'),
              content: const Text(
                  'Do you want to leave this page? Any unsaved changes will be lost.'),
              actions: [
                TextButton(
                  onPressed: () {
                    // If the user confirms, set _confirmedExit to true and pop the dialog
                    setState(() {
                      _confirmedExit = true;
                    });
                    _processData();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminHomePage()),
                    );
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    // If the user cancels, do nothing and pop the dialog
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
              ],
            ),
          );
          return false;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).secondaryHeaderColor),
              onPressed: () {
                // Add your navigation logic here, such as pop or navigate back
                Navigator.of(context).pop();
              },
            ),
            title: Text('Create User',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).secondaryHeaderColor,
                )),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(children: [
                          Expanded(
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(22.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 8.0),
                                        child: Text(
                                          'User Name',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _idFieldController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter username',
                                          fillColor: Colors.blue,
                                          labelStyle: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .hintColor),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.green),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        onChanged: (value) =>
                                            setState(() => userID = value),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(22.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 8.0),
                                        child: Text(
                                          'Create Password',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _passFieldController,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Password must be atleast 8 characters',
                                          fillColor: Colors.blue,
                                          labelStyle: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .hintColor),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.green),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        onChanged: (value) =>
                                            setState(() => password = value),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(22.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 8.0),
                                        child: Text(
                                          'Confirm Password',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _confpassFieldController,
                                        decoration: InputDecoration(
                                          hintText: 'Re enter password',
                                          fillColor: Colors.blue,
                                          labelStyle: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .hintColor),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.green),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        onChanged: (value) => setState(
                                            () => confirmPassword = value),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children:
                                      List.generate(chipLabels.length, (index) {
                                    return ChoiceChip(
                                      backgroundColor: isSelected[index]
                                          ? null
                                          : Colors.grey[700],
                                      label: Text(
                                        chipLabels[index],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      selected: isSelected[index],
                                      selectedColor: _getSelectedColor(index),
                                      onSelected: (bool selected) {
                                        setState(() {
                                          for (int i = 0;
                                              i < isSelected.length;
                                              i++) {
                                            isSelected[i] =
                                                i == index ? selected : false;
                                            selected_role_id =
                                                chipLabelsid[index];
                                            // print(
                                            //     'crit level: $incident_criticality_id');
                                          }
                                          isRoleSelected = true;
                                        });
                                      },
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              onPressed: isSubmitting
                                  ? null
                                  : () async {
                                      if (userID != '' &&
                                          password != '' &&
                                          confirmPassword != '' &&
                                          isRoleSelected) {
                                        // setState(() {
                                        //   isSubmitting = true;
                                        // });
                                        int flag = await handleReportSubmitted(
                                            context, this);

                                        if (flag == 1) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Colors.blue,
                                                content: Text('User Created'),
                                                duration: Duration(seconds: 3),
                                              ),
                                            );
                                            _processData();
                                            // setState(() {
                                            // });

                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AdminHomePage()),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              backgroundColor: Colors.redAccent,
                                              content:
                                                  Text('Failed: Please retry'),
                                              duration: Duration(seconds: 3),
                                            ));
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            content:
                                                Text('Unable to Create User'),
                                            duration: Duration(seconds: 3),
                                          ));
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          content: Text(
                                              'Please Fill all required fields'),
                                          duration: Duration(seconds: 3),
                                        ));
                                      }
                                    },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: SizedBox(
                                    // height: MediaQuery.sizeOf(context).height *
                                    //     0.04,
                                    child: isSubmitting
                                        ? SizedBox(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  "Creating..",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.03,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.03,
                                                  child:
                                                      const CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.03,
                                            child: const Center(
                                              child: Text(
                                                "Create",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )),
                              ),
                            ),
                          ),
                        ]),
                      ))),
            ),
          )),
    );
  }

  Future<int> handleReportSubmitted(
      BuildContext context, _CreatUserFormState userFormState) async {
    setState(() {
      isSubmitting = true;
    });
    // print("presse");

    // await Future.delayed(Duration(seconds: 2));

    // return -1;

    UserServices userServices = UserServices();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? user_id = prefs.getString("this_user_id");
    // int? user_report_id = prefs.getInt("user_report_id");

    // if (user_id != null && user_report_id != null) {
    int flag = await userServices.createUser(
        userFormState.userID,
        userFormState.userID,
        userFormState.password,
        userFormState.selected_role_id);
    setState(() {
      isSubmitting = false;
    });
    return flag;
  }
}
