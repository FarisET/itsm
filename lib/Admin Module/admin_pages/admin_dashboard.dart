import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/providers/action_team_efficiency_provider.dart';
import 'package:safify/Admin%20Module/providers/analytics_incident_reported_provider.dart';
import 'package:safify/Admin%20Module/providers/analytics_incident_resolved_provider.dart';
import 'package:safify/Admin%20Module/providers/fetch_countOfLocations_provider%20copy.dart';
import 'package:safify/Admin%20Module/providers/fetch_countOfSubtypes_provider.dart';
import 'package:safify/User%20Module/pages/login_page.dart';
import 'package:safify/repositories/analytics_repository.dart';
import 'package:safify/services/UserServices.dart';
import 'package:safify/components/shimmer_box.dart';
import 'package:safify/models/action_team_efficiency.dart';
import 'package:safify/models/count_incidents_by_location.dart';
import 'package:safify/models/count_incidents_by_subtype.dart';
import 'package:safify/services/toast_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final double mainHeaderSize = 18;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use the mounted property to ensure the widget is still mounted
      if (mounted) {
        Provider.of<CountIncidentsResolvedProvider>(context, listen: false)
            .getCountResolvedPostData();
        Provider.of<CountIncidentsReportedProvider>(context, listen: false)
            .getCountReportedPostData();
        Provider.of<CountByIncidentSubTypesProviderClass>(context,
                listen: false)
            .getcountByIncidentSubTypesPostData();
        Provider.of<CountByLocationProviderClass>(context, listen: false)
            .getcountByIncidentLocationPostData();
        Provider.of<ActionTeamEfficiencyProviderClass>(context, listen: false)
            .getactionTeamEfficiencyData();

        AnalyticsRepository().updateAnalytics(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countResolvedProvider =
        Provider.of<CountIncidentsResolvedProvider>(context)
            .totalIncidentsResolved;
    final countReportedProvider =
        Provider.of<CountIncidentsReportedProvider>(context)
            .totalIncidentsReported;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).secondaryHeaderColor),
          onPressed: () {
            dispose();
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Reporting Analytics",
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
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Logout'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
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
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final value = await AnalyticsRepository().updateAnalytics(context);
          if (value.contains("success")) {
            ToastService.showUpdatedLocalDbSuccess(context);
          } else {
            ToastService.showFailedToFetchReportsFromServer(context);
          }
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  leading: const Icon(
                    Icons.personal_injury,
                    color: Colors.black,
                    size: 31,
                  ),
                  title: const Text('Total Incidents Reported'),
                  trailing: CircleAvatar(
                    maxRadius: 16,
                    backgroundColor: Theme.of(context).cardColor,
                    child: Text(
                      countReportedProvider ?? '',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  leading: const Icon(
                    Icons.check_box,
                    color: Colors.black,
                    size: 31,
                  ),
                  title: const Text('Total Incidents Resolved'),
                  trailing: CircleAvatar(
                    maxRadius: 16,
                    backgroundColor: Theme.of(context).cardColor,
                    child: Text(
                      countResolvedProvider != null
                          ? countResolvedProvider!
                          : '',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            _buildIncidentSubtypeChart(),
            _buildIncidentLocationChart(),
            _buildActionTeamEfficiencyChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentSubtypeChart() {
    return Consumer<CountByIncidentSubTypesProviderClass>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return ShimmerBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.sizeOf(context).height * 0.3,
          );
        }
        final data = provider.countByIncidentSubTypes
                ?.where((item) => item.incident_count! > 0)
                .toList() ??
            [];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            elevation: 3,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.category,
                        color: Colors.black,
                        size: 31,
                      ),
                      Text(
                        'Types of Incidents Breakdown',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text('')
                    ],
                  ),
                  SizedBox(
                    height: 200,
                    child: SfCircularChart(
                      title: const ChartTitle(text: 'Incident Subtypes'),
                      legend: const Legend(isVisible: true),
                      series: <CircularSeries>[
                        PieSeries<CountByIncidentSubTypes, String>(
                          dataSource: data,
                          xValueMapper: (CountByIncidentSubTypes item, _) =>
                              item.incident_subtype_description,
                          yValueMapper: (CountByIncidentSubTypes item, _) =>
                              item.incident_count,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIncidentLocationChart() {
    return Consumer<CountByLocationProviderClass>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return ShimmerBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.sizeOf(context).height * 0.3,
          );
        }
        final data = provider.countByLocation
                ?.where((item) => item.incident_count! > 0)
                .toList() ??
            [];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            elevation: 3,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.black,
                        size: 31,
                      ),
                      Text(
                        'Incidents Breakdown by Location',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text('')
                    ],
                  ),
                  SizedBox(
                    height: 200,
                    child: SfCircularChart(
                      title: const ChartTitle(text: 'Incident Locations'),
                      legend: const Legend(isVisible: true),
                      series: <CircularSeries>[
                        PieSeries<CountByLocation, String>(
                          dataSource: data,
                          xValueMapper: (CountByLocation item, _) =>
                              item.location_name,
                          yValueMapper: (CountByLocation item, _) =>
                              item.incident_count,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionTeamEfficiencyChart() {
    return Consumer<ActionTeamEfficiencyProviderClass>(
        builder: (context, provider, child) {
      if (provider.loading) {
        return ShimmerBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.sizeOf(context).height * 0.3,
        );
      }
      final data = provider.actionTeamEfficiency
              // ?.where((item) => double.tryParse(item.efficiency_value!)! > 0)
              ?.where((item) => item.efficiency_value! > 0)
              .toList() ??
          [];

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 3,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.group,
                      color: Colors.black,
                      size: 31,
                    ),
                    Text(
                      'Action Team Efficiencies',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text('')
                  ],
                ),
                SizedBox(
                  height: 200,
                  child: SfCartesianChart(
                    primaryXAxis: const CategoryAxis(),
                    title: const ChartTitle(text: 'Team Efficiency'),
                    series: <CartesianSeries>[
                      BarSeries<ActionTeamEfficiency, String>(
                        dataSource: data,
                        xValueMapper: (ActionTeamEfficiency data, _) =>
                            data.action_team_name,
                        yValueMapper: (ActionTeamEfficiency data, _) =>
                            // double.tryParse(data.efficiency_value ?? '0') ??
                            data.efficiency_value ?? 0.0,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void handleLogout(BuildContext context) async {
    UserServices userServices = UserServices();
    await userServices.logout();
  }
}

// class CountByIncidentSubTypes {
//   final String incident_subtype_description;
//   final int incident_count;

//   CountByIncidentSubTypes(
//       this.incident_subtype_description, this.incident_count);
// }

// class CountByLocation {
//   final String location_name;
//   final int incident_count;

//   CountByLocation(this.location_name, this.incident_count);
// }

// class ActionTeamEfficiency {
//   final String action_team_name;
//   final double efficiency_value;

//   ActionTeamEfficiency(this.action_team_name, this.efficiency_value);
// }
