import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/Action%20Team%20Module/providers/action_reports_provider.dart';
import 'package:safify/Admin%20Module/admin_pages/admin_dashboard.dart';
import 'package:safify/Admin%20Module/providers/admin_user_reports_provider.dart';
import 'package:safify/User%20Module/pages/login_page.dart';
import 'package:safify/services/UserServices.dart';
import 'package:safify/services/toast_service.dart';
import 'package:safify/widgets/admin_action_reports_list.dart';
import 'package:safify/widgets/admin_user_reports_list.dart';
import 'package:safify/widgets/app_drawer_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  String? user_name;
  String? user_id;
  final double mainHeaderSize = 18;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   Provider.of<CountIncidentsResolvedProvider>(context, listen: false)
    //       .getCountResolvedPostData();
    //   Provider.of<CountIncidentsReportedProvider>(context, listen: false)
    //       .getCountReportedPostData();
    //   Provider.of<CountByIncidentSubTypesProviderClass>(context, leisten: false)
    //       .getcountByIncidentSubTypesPostData();
    //   Provider.of<CountByLocationProviderClass>(context, listen: false)
    //       .getcountByIncidentLocationPostData();
    //   Provider.of<ActionTeamEfficiencyProviderClass>(context, listen: false)
    //       .getactionTeamEfficiencyData();
    // });
    getUsername();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  UserServices userServices = UserServices();

  void getUsername() {
    SharedPreferences.getInstance().then((prefs) async {
      user_name = await userServices.getName();
      setState(() {
        // print('user_name: $user_name');
        user_id = prefs.getString("user_id");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final countResolvedProvider =
    //     Provider.of<CountIncidentsResolvedProvider>(context)
    //         .totalIncidentsResolved;
    // final countReportedProvider =
    //     Provider.of<CountIncidentsReportedProvider>(context)
    //         .totalIncidentsReported;
    // final countByIncidentSubTypeProvider =
    //     Provider.of<CountByIncidentSubTypesProviderClass>(context)
    //         .countByIncidentSubTypes;
    // final countByLocationProvider =
    //     Provider.of<CountByLocationProviderClass>(context, listen: false)
    //         .countByLocation;
    // final actionTeamEfficiencyProvider =
    //     Provider.of<ActionTeamEfficiencyProviderClass>(context, listen: false)
    //         .actionTeamEfficiency;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight * 0.7;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     ToastService.showRejectedReportSnackBar(context, true);
        //   },
        //   child: const Icon(Icons.analytics_outlined),
        // ),
        // floatingActionButton: FloatingActionButton(
        //   child: const Icon(Icons.notifications),
        //   onPressed: () async {
        //     Future.delayed(const Duration(seconds: 0), () {
        //       NotifTestService.testNotif();
        //     });
        //     // await DatabaseHelper().clearDBdata();
        //     // print(await DatabaseHelper().getAdminUserReports());
        //   },
        // ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(builder: (context) {
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).primaryColor,
                ),
                // onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                onPressed: () =>
                    Scaffold.of(context).openDrawer(), // Open drawer on tap
              );
            }),
          ),
          title: Text(
            "Home",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: mainHeaderSize,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // Show confirmation dialog before logging out
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
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ],
        ),
        drawer: AppDrawer(
          username: user_id!,
        ),

        //     backgroundColor: Colors.blue[600],
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.05,
                vertical: MediaQuery.sizeOf(context).height * 0.02),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //Text
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              user_name != null
                                  ? Flexible(
                                      child: Text(
                                        '$user_name',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : const Text(
                                      'Citizen',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.007,
                              ),
                              Text(
                                  intl.DateFormat('d MMMM y')
                                      .format(DateTime.now()),
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                            ],
                          ),

                          //dashboard
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AdminDashboard()),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.analytics_outlined,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      ' Dashboard',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                    ],
                  ),
                ),

                //Reports tab
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TabBar(
                    labelColor: Colors
                        .white, // Color for all labels (unused in this approach)
                    unselectedLabelColor: Colors.black,
                    labelStyle: const TextStyle(
                      fontWeight:
                          FontWeight.bold, // Style for the selected tab's label
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight:
                          FontWeight.bold, // Style for unselected tabs' labels
                    ),
                    indicator: BoxDecoration(
                      // Decoration for the indicator below the selected tab
                      color: Colors.blue[500],
                      borderRadius:
                          BorderRadius.circular(10), // You can adjust the shape
                    ),
                    controller: _tabController,
                    tabs: const <Widget>[
                      Tab(
                        text: 'User Reports',
                      ),
                      Tab(
                        text: 'Action Reports',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: containerHeight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: <Widget>[
                                    RefreshIndicator(
                                        onRefresh: () async {
                                          final value = await Provider.of<
                                                      AdminUserReportsProvider>(
                                                  context,
                                                  listen: false)
                                              .fetchAdminUserReports(context);
                                          if (value.contains("success")) {
                                            ToastService
                                                .showUpdatedLocalDbSuccess(
                                                    context);
                                          } else {
                                            ToastService
                                                .showFailedToFetchReportsFromServer(
                                                    context);
                                          }
                                        },
                                        child: const AdminUserReportsList()),
                                    RefreshIndicator(
                                        onRefresh: () async {
                                          final value = await Provider.of<
                                                      ActionReportsProvider>(
                                                  context,
                                                  listen: false)
                                              .fetchAllActionReports(context);
                                          if (value.contains("success")) {
                                            ToastService
                                                .showUpdatedLocalDbSuccess(
                                                    context);
                                          } else {
                                            ToastService
                                                .showFailedToFetchReportsFromServer(
                                                    context);
                                          }
                                        },
                                        child:
                                            const AdminActionReportsList()) // Replace with Action Team Reports widget
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
}
