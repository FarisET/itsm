import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../services/report_service.dart';
import '../../models/action_team.dart';
import '../../models/department.dart';
import '../../widgets/build_dropdown_menu_util.dart';
import '../providers/action_team_provider.dart';
import '../providers/department_provider.dart';
import 'admin_home_page.dart';

class AssignFormOld extends StatefulWidget {
  const AssignFormOld({super.key, Key});

  @override
  State<AssignFormOld> createState() => _AssignFormOldState();
}

class _AssignFormOldState extends State<AssignFormOld> {
  final _formKey = GlobalKey<FormState>();
  int selectedChipIndex = -1;
  List<bool> isSelected = [false, false, false];
  List<String> chipLabels = ['Minor', 'Serious', 'Critical'];
  List<String> chipLabelsid = ['CRT1', 'CRT2', 'CRT3'];
  String actionTeam = '';
  List<String> dropdownMenuEntries = [];
  String? user_id;
  bool _confirmedExit = false;
  bool isRiskLevelSelected = false;
  String? selectedRiskLevel;

  void _processData() {
    // Process your data and upload to the server
    _formKey.currentState?.reset();
  }

  Color? _getSelectedColor(int index) {
    if (isSelected[index]) {
      if (index == 0) {
        return const Color.fromARGB(255, 6, 209, 70);
      } else if (index == 1) {
        return const Color.fromARGB(255, 255, 135, 22);
      } else if (index == 2) {
        return Colors.redAccent;
      }
    }
    return null;
  }

  int id = 0; // auto-generated
  String description = '';
  DateTime date = DateTime.now();
  bool status =
      false; // how to update, initially false, will be changed by admin.
  String incident_criticality_id = '';
  File? selectedImage; // Declare selectedImage as nullable
  String title = "PPE Violation";
  String? SelectedDepartment;

  bool isSubmitting = false;

  DropdownMenuItem<String> buildDepartmentMenuItem(Department type) {
    return DropdownMenuItemUtil.buildDropdownMenuItem<Department>(
      type,
      type.Department_ID,
      type.Department_Name,
      // Add the condition to check if it's selected based on your logic
    );
  }

  DropdownMenuItem<String> buildActionTeamMenuItem(ActionTeam type) {
    return DropdownMenuItemUtil.buildDropdownMenuItem<ActionTeam>(
        type, type.ActionTeam_ID, type.ActionTeam_Name
        // Add the condition to check if it's selected based on your logic
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<DepartmentProviderClass>(context, listen: false)
          .getDepartmentPostData();
      if (SelectedDepartment != null) {
        Provider.of<ActionTeamProviderClass>(context, listen: false)
            .getActionTeamPostData(SelectedDepartment!);
      }
    });
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
                      SelectedDepartment = null;
                    });
                    _processData();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminHomePage()),
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
            title: Text('Assign Task',
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
                                const SizedBox(
                                  height: 10,
                                ),
                                Consumer<DepartmentProviderClass>(
                                  builder: (context, selectedVal, child) {
                                    if (selectedVal.loading) {
                                      return const Center(
                                        child:
                                            CircularProgressIndicator(), // Display a loading indicator
                                      );
                                    } else {
                                      return Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: FormField<String>(
                                          builder:
                                              (FormFieldState<String> state) {
                                            return DropdownButton<String>(
                                              value: selectedVal
                                                  .selectedDepartment,
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              isExpanded: true,
                                              icon: const Icon(Icons.arrow_drop_down,
                                                  color: Colors.blue),
                                              underline: Container(),
                                              items: [
                                                const DropdownMenuItem<String>(
                                                  value:
                                                      null, // Placeholder value
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                        'Select department'),
                                                  ),
                                                ),
                                                if (selectedVal
                                                        .departmentPost !=
                                                    null)
                                                  ...selectedVal.departmentPost!
                                                      .map((type) {
                                                    return buildDepartmentMenuItem(
                                                        type);
                                                  }).toList(),
                                              ],
                                              onChanged: (v) {
                                                print(
                                                    'Selected Department: $v');
                                                selectedVal
                                                    .setDepartmentType(v);
                                                SelectedDepartment = v!;
                                                Provider.of<ActionTeamProviderClass>(
                                                        context,
                                                        listen: false)
                                                    .selectedActionTeam = null;
                                                Provider.of<ActionTeamProviderClass>(
                                                        context,
                                                        listen: false)
                                                    .getActionTeamPostData(v);
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Consumer<ActionTeamProviderClass>(
                                    builder: (context, selectedValue, child) {
                                  if (SelectedDepartment != null) {
                                    if (selectedValue.loading) {
                                      return const Center(
                                        child:
                                            CircularProgressIndicator(), // Display a loading indicator
                                      );
                                    } else {
                                      return Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: FormField<String>(
                                          builder:
                                              (FormFieldState<String> state) {
                                            return DropdownButton<String>(
                                              value: selectedValue
                                                  .selectedActionTeam,
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              isExpanded: true,
                                              icon: const Icon(Icons.arrow_drop_down,
                                                  color: Colors.blue),
                                              underline: Container(),
                                              items: [
                                                const DropdownMenuItem<String>(
                                                  value:
                                                      null, // Placeholder value
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                        'Select action team'),
                                                  ),
                                                ),
                                                if (selectedValue
                                                        .actionTeamPost !=
                                                    null)
                                                  ...selectedValue
                                                      .actionTeamPost!
                                                      .map((type) {
                                                    return buildActionTeamMenuItem(
                                                        type);
                                                  }).toList(),
                                              ],
                                              onChanged: (v) {
                                                print(
                                                    'Selected Action Team: $v');
                                                selectedValue.setActionTeam(v);
                                                actionTeam = v!;
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  } else {
                                    return Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  'Please select a department first',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  )),
                                              Icon(Icons.arrow_drop_down,
                                                  color: Colors.grey)
                                            ],
                                          ),
                                        ));
                                  }
                                }),
                                const SizedBox(
                                  height: 15,
                                ),
                                DropdownButtonFormField<String>(
                                  value: selectedRiskLevel,
                                  decoration: InputDecoration(
                                    labelText: 'Select Risk Level',
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                  ),
                                  items:
                                      List.generate(chipLabels.length, (index) {
                                    return DropdownMenuItem<String>(
                                      value: chipLabelsid[index],
                                      child: Text(chipLabels[index]),
                                    );
                                  }),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRiskLevel = value;
                                      incident_criticality_id = value!;
                                      isRiskLevelSelected = true;
                                    });
                                  },
                                  validator: (value) => value == null
                                      ? 'Please select a risk level'
                                      : null,
                                ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceAround,
                                //   children:
                                //       List.generate(chipLabels.length, (index) {
                                //     return ChoiceChip(
                                //       backgroundColor: isSelected[index]
                                //           ? null
                                //           : Colors.grey[300],
                                //       label: Text(
                                //         chipLabels[index],
                                //         style: TextStyle(color: Colors.white),
                                //       ),
                                //       selected: isSelected[index],
                                //       selectedColor: _getSelectedColor(index),
                                //       onSelected: (bool selected) {
                                //         setState(() {
                                //           for (int i = 0;
                                //               i < isSelected.length;
                                //               i++) {
                                //             isSelected[i] =
                                //                 i == index ? selected : false;
                                //             incident_criticality_id =
                                //                 chipLabelsid[index];
                                //             // print(
                                //             //     'crit level: $incident_criticality_id');
                                //           }
                                //           isRiskLevelSelected = true;
                                //         });
                                //       },
                                //     );
                                //   }),
                                // ),
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
                                      if (SelectedDepartment != '' &&
                                          SelectedDepartment != null &&
                                          actionTeam != '' &&
                                          isRiskLevelSelected) {
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
                                                content: Text('Task Assigned'),
                                                duration: Duration(seconds: 3),
                                              ),
                                            );
                                            _processData();
                                            setState(() {
                                              SelectedDepartment = null;
                                            });

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
                                            content: Text('Assignment Failed'),
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
                                                  "Assigning..",
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
                                                "Assign",
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
      BuildContext context, _AssignFormOldState userFormState) async {
    setState(() {
      isSubmitting = true;
    });
    // print("presse");

    // await Future.delayed(Duration(seconds: 2));

    // return -1;

    ReportServices reportServices = ReportServices();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString("this_user_id");
    int? user_report_id = prefs.getInt("user_report_id");

    if (user_id != null && user_report_id != null) {
      int flag = await reportServices.postAssignedReport(
        user_report_id,
        user_id,
        userFormState.actionTeam,
        userFormState.incident_criticality_id,
      );
      setState(() {
        isSubmitting = false;
      });
      return flag;
    }
    setState(() {
      isSubmitting = false;
    });
    return 0;
  }
}
