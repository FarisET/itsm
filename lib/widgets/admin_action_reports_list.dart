import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/User%20Module/pages/login_page.dart';
import 'package:safify/services/UserServices.dart';
import 'package:safify/utils/alerts_util.dart';
import 'package:safify/widgets/admin_action_report_tile.dart';
import '../Action Team Module/providers/action_reports_provider.dart';

class AdminActionReportsList extends StatefulWidget {
  const AdminActionReportsList({super.key});

  @override
  State<AdminActionReportsList> createState() => _AdminActionReportsListState();
}

class _AdminActionReportsListState extends State<AdminActionReportsList> {
  @override
  void initState() {
    super.initState();
    if (Provider.of<ActionReportsProvider>(context, listen: false).reports ==
        null) {
      Provider.of<ActionReportsProvider>(context, listen: false)
          .fetchAllActionReports(context);
    }
  }

  void _handleSessionExpired(BuildContext context) async {
    UserServices userServices = UserServices();
    bool res = await userServices.logout();
    if (res) {
      // Logout successful, show alert and wait for user interaction
      Alerts.customAlertTokenWidget(
        context,
        "Your session expired or timed-out, please log in to continue.",
        () {
          // Navigator to login page only when user clicks "Close"
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
      );
    } else {
      // Handle logout failure if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Consumer<ActionReportsProvider>(
        builder: (context, actionReportsProvider, _) {
      if (actionReportsProvider.error != null &&
          actionReportsProvider.error!.contains('TokenExpiredException')) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _handleSessionExpired(context));
      }

      if (actionReportsProvider.reports != null) {
        if (actionReportsProvider.reports!.isNotEmpty) {
          return ListView.builder(
            itemCount: actionReportsProvider.reports!.length,
            itemBuilder: (context, i) {
              var item = actionReportsProvider.reports![i];

              return AdminActionReportTile(actionReport: item);
            },
          );
        } else if (actionReportsProvider.reports!.isEmpty &&
            actionReportsProvider.isLoading) {
          return const CircularProgressIndicator();
        }
      }
      if (actionReportsProvider.reports == null) {
        return const CircularProgressIndicator();
      }
      if (actionReportsProvider.reports!.isEmpty) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No reports found'),
            IconButton(
                onPressed: () {
                  Provider.of<ActionReportsProvider>(context, listen: false)
                      .fetchAllActionReports(context);
                },
                icon: const Icon(Icons.refresh))
          ],
        );
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Failed to load reports'),
          IconButton(
              onPressed: () {
                Provider.of<ActionReportsProvider>(context, listen: false)
                    .fetchAllActionReports(context);
              },
              icon: const Icon(Icons.refresh))
        ],
      );
    }));
  }
}
