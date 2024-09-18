import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/providers/admin_user_reports_provider.dart';
import 'package:safify/widgets/search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/report_service.dart';
import '../../models/action_team.dart';
import '../providers/all_action_team_provider.dart';
import 'admin_home_page.dart';

class AssignForm extends StatefulWidget {
  const AssignForm({super.key});

  @override
  State<AssignForm> createState() => _AssignFormState();
}

class _AssignFormState extends State<AssignForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();
  String actionTeam = '';
  String? selectedRiskLevel;
  String? selectedFilter;
  bool isSubmitting = false;
  List<ActionTeam> filteredActionTeams = [];
  int selectedChipIndex = -1;
  List<bool> isSelected = [false, false, false];
  List<String> chipLabels = ['Minor', 'Serious', 'Critical'];
  List<String> chipLabelsid = ['CRT1', 'CRT2', 'CRT3'];
  String? user_id;
  bool _confirmedExit = false;
  bool isRiskLevelSelected = false;
  String? incident_criticality_id = '';

  void _processData() {
    _formKey.currentState?.reset();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AllActionTeamProviderClass>(context, listen: false)
          .fetchAllActionTeams();
      filterActionTeams('');
    });
  }

  void filterActionTeams(String query) {
    final allActionTeams =
        Provider.of<AllActionTeamProviderClass>(context, listen: false)
                .allActionTeams ??
            [];
    setState(() {
      filteredActionTeams = allActionTeams.where((team) {
        final matchesQuery =
            team.ActionTeam_Name.toLowerCase().contains(query.toLowerCase());
        final matchesFilter =
            selectedFilter == null || team.department_name == selectedFilter;
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  void _handleActionTeamSelected(String actionTeamName) {
    setState(() {
      actionTeam = actionTeamName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final actionTeamProvider =
        Provider.of<AllActionTeamProviderClass>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        if (isSubmitting) {
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).secondaryHeaderColor),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              'Assign Task',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text("Select Action Team: $actionTeam",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 10),
                          CustomSearchBar(
                            controller: searchController,
                            onSearchChanged: filterActionTeams,
                            onFilterChanged: (filter) {
                              setState(() {
                                selectedFilter = filter;
                              });
                              filterActionTeams(searchController.text);
                            },
                            filterOptions: actionTeamProvider.allActionTeams
                                    ?.map((team) => team.department_name)
                                    .whereType<String>()
                                    .toSet()
                                    .toList() ??
                                [],
                            actionTeams: filteredActionTeams,
                            onActionTeamSelected:
                                _handleActionTeamSelected, // Handle selection
                          ),
                          const SizedBox(height: 20),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Selected Risk Level:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: selectedRiskLevel,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: 'Select Risk Level',
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                            items: List.generate(chipLabels.length, (index) {
                              return DropdownMenuItem<String>(
                                value: chipLabelsid[index],
                                child: Text(chipLabels[index]),
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                selectedRiskLevel = value;
                                incident_criticality_id = value!;
                              });
                            },
                            validator: (value) => value == null
                                ? 'Please select a risk level'
                                : null,
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.sizeOf(context).height * 0.05,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: isSubmitting
                                  ? null
                                  : () async {
                                      if (actionTeam != '' &&
                                          selectedRiskLevel != null) {
                                        int result =
                                            await handleReportSubmitted(
                                                context, this);
                                        if (result == 1) {
                                          await Provider.of<
                                                      AdminUserReportsProvider>(
                                                  context,
                                                  listen: false)
                                              .fetchAdminUserReports(context);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                                const SnackBar(
                                                  backgroundColor: Colors.blue,
                                                  content: Text(
                                                      'Report assigned successfully!'),
                                                  duration:
                                                      Duration(seconds: 3),
                                                ),
                                              )
                                              .closed
                                              .then((_) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AdminHomePage()),
                                            );
                                          });
                                        } else if (result == 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.redAccent,
                                              content:
                                                  Text('Failed: Please retry'),
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            content: Text(
                                                'Please Fill all required fields'),
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                      }
                                    },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9),
                                child: SizedBox(
                                  child: isSubmitting
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Assigning..",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(width: 20),
                                            SizedBox(
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.04,
                                              width: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.04,
                                              child:
                                                  const CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const Center(
                                          child: Text(
                                            "Assign",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<int> handleReportSubmitted(
      BuildContext context, _AssignFormState userFormState) async {
    setState(() {
      isSubmitting = true;
    });

    ReportServices reportServices = ReportServices();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString("this_user_id");
    int? user_report_id = prefs.getInt("user_report_id");

    if (user_id != null && user_report_id != null) {
      int flag = await reportServices.postAssignedReport(
        user_report_id,
        user_id,
        userFormState.actionTeam,
        userFormState.incident_criticality_id!,
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
