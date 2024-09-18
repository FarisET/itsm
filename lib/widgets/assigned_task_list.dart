import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/User%20Module/pages/login_page.dart';
import 'package:safify/services/UserServices.dart';
import 'package:safify/utils/alerts_util.dart';
import 'package:safify/widgets/assigned_task_tile.dart';
import '../Action Team Module/providers/assigned_tasks_provider.dart';

class AssignedTaskList extends StatefulWidget {
  const AssignedTaskList({super.key});

  @override
  State<AssignedTaskList> createState() => _AssignedTaskListState();
}

class _AssignedTaskListState extends State<AssignedTaskList> {
  @override
  void initState() {
    super.initState();
    Provider.of<AssignedTasksProvider>(context, listen: false)
        .fetchAssignedTasks(context);
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
        Consumer<AssignedTasksProvider>(builder: (context, assignProvider, _) {
      // return Icon(Icons.error_outline);
      if (assignProvider.isLoading) {
        return const CircularProgressIndicator();
      }
      if (assignProvider.error != null) {
        if (assignProvider.error!.contains('TokenExpiredException')) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _handleSessionExpired(context));
          return const Text("Failed to load tasks, session expired.");
        }
        if (assignProvider.error!.contains('SocketException')) {
          return SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(width: 8.0),
                const Flexible(
                  child: const Text("Please check your internet connection."),
                ),
              ],
            ),
          );
        }
      }

      if (assignProvider.tasks != null) {
        if (assignProvider.tasks!.isNotEmpty) {
          return ListView.builder(
            itemCount: assignProvider.tasks!.length,
            itemBuilder: (context, i) {
              var item = assignProvider.tasks![i];

              return AssignedTaskTile(task: item);
            },
          );
        }
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Failed to load tasks'),
          IconButton(
              onPressed: () {
                Provider.of<AssignedTasksProvider>(context, listen: false)
                    .fetchAssignedTasks(context);
              },
              icon: const Icon(Icons.refresh))
        ],
      );
    }));
  }
  // padding: const EdgeInsets.only(bottom:8.0),
  //child: Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  // //       border: Border(
  // //       left: BorderSide(
  // //     color: status!=null && status ? Colors.green : Colors.red,
  // //     width: 1.0, // Adjust the width as needed
  // //   ),
  // // ),
  //     ),
}
