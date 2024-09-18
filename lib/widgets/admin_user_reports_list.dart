import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/User%20Module/pages/login_page.dart';
import 'package:safify/services/UserServices.dart';
import 'package:safify/utils/alerts_util.dart';
import 'package:safify/widgets/admin_user_report_tile.dart';

import '../Admin Module/providers/admin_user_reports_provider.dart';

class AdminUserReportsList extends StatefulWidget {
  const AdminUserReportsList({super.key});

  @override
  State<AdminUserReportsList> createState() => _AdminUserReportsListState();
}

class _AdminUserReportsListState extends State<AdminUserReportsList> {
  @override
  void initState() {
    super.initState();
    if (Provider.of<AdminUserReportsProvider>(context, listen: false).reports ==
        null) {
      final result =
          Provider.of<AdminUserReportsProvider>(context, listen: false)
              .fetchAdminUserReports(context);
      // result.then(
      //   (value) {
      //     if (value.contains("success")) {
      //       ToastService.showUpdatedLocalDbSuccess(context);
      //     } else {
      //       ToastService.showFailedToFetchReportsFromServer(context);
      //     }
      //   },
      // );
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
    return Center(child: Consumer<AdminUserReportsProvider>(
        builder: (context, adminUserReportsProvider, _) {
      if (adminUserReportsProvider.error != null &&
          adminUserReportsProvider.error!.contains('TokenExpiredException')) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _handleSessionExpired(context));
      }
      if (adminUserReportsProvider.reports != null) {
        if (adminUserReportsProvider.reports!.isNotEmpty) {
          return ListView.builder(
            itemCount: adminUserReportsProvider.reports!.length,
            itemBuilder: (context, i) {
              var item = adminUserReportsProvider.reports![i];

              return AdminUserReportTile(userReport: item);
            },
          );
        } else if (adminUserReportsProvider.reports!.isEmpty &&
            adminUserReportsProvider.isLoading) {
          return const CircularProgressIndicator();
        }
      }
      if (adminUserReportsProvider.reports == null) {
        return const CircularProgressIndicator();
      }
      if (adminUserReportsProvider.reports!.isEmpty) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No reports found'),
            IconButton(
                onPressed: () {
                  Provider.of<AdminUserReportsProvider>(context, listen: false)
                      .fetchAdminUserReports(context);
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
                Provider.of<AdminUserReportsProvider>(context, listen: false)
                    .fetchAdminUserReports(context);
              },
              icon: const Icon(Icons.refresh))
        ],
      );
    }));
  }

  bool isBase64(String data) {
    final RegExp base64Regex = RegExp(
      r'^([A-Za-z0-9+/]{4})*(([A-Za-z0-9+/]{2}==)|([A-Za-z0-9+/]{3}=))?$',
      multiLine: true,
    );
    return base64Regex.hasMatch(data);
  }
}
