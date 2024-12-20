import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/User%20Module/pages/login_page.dart';
import 'package:safify/components/custom_button.dart';
import 'package:safify/services/UserServices.dart';
import 'package:safify/utils/alerts_util.dart';
import 'package:safify/utils/string_utils.dart';
import 'package:safify/widgets/user_report_tile.dart';

import '../User Module/providers/user_reports_provider.dart';

class UserReportList extends StatefulWidget {
  const UserReportList({super.key});

  @override
  State<UserReportList> createState() => _UserReportListState();
}

class _UserReportListState extends State<UserReportList> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserReportsProvider>(context, listen: false)
        .fetchReports(context);
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
    return Center(child:
        Consumer<UserReportsProvider>(builder: (context, reportProvider, _) {
      if (reportProvider.error != null &&
          reportProvider.error!.contains('TokenExpiredException')) {
        if (reportProvider.error!.contains('TokenExpiredException')) {
          reportProvider.error = null;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _handleSessionExpired(context));
        }
        // return
        // Center(child: Text('Error: ${reportProvider.error}'));
      }
      if (reportProvider.reports.isNotEmpty) {
        return ListView.builder(
          itemCount: reportProvider.reports.length,
          itemBuilder: (context, i) {
            var item = reportProvider.reports[i];

            return UserReportTile(userReport: item);
          },
        );
      } else if (reportProvider.reports.isEmpty && reportProvider.isLoading) {
        return const CircularProgressIndicator();
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('No Reports'),
          IconButton(
              onPressed: () {
                Provider.of<UserReportsProvider>(context, listen: false)
                    .fetchReports(context);
              },
              icon: const Icon(Icons.refresh))
        ],
      );
    }));
  }
}
