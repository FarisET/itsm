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
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).secondaryHeaderColor,
          ),
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
          // Refresh logic
        },
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _buildHeader(context),
            const Divider(height: 30, thickness: 1.5),
            _buildStatisticsGrid(context),
            const SizedBox(height: 20),
            _buildChartsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        'Dashboard',
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).secondaryHeaderColor,
            ),
      ),
    );
  }

  Widget _buildStatisticsGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate crossAxisCount based on screen width
        int crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            final icons = [
              Icons.personal_injury,
              Icons.check_box,
              Icons.category,
              Icons.group
            ];
            final titles = [
              'Total Tickets this Year',
              'Tickets Closed this Year',
              'Departments',
              'Action Teams'
            ];
            final counts = ['150', '120', '12', '8'];
            return _buildStatCard(
              context,
              icon: icons[index],
              title: titles[index],
              count: counts[index],
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String count,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Theme.of(context).primaryColor, size: 30),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium,
                    softWrap: true,
                    overflow: TextOverflow.visible, // Allow text to wrap
                    maxLines: 2, // Allow up to 2 lines
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              count,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIncidentSubtypeChart(),
        const SizedBox(height: 20),
        _buildIncidentLocationChart(),
        const SizedBox(height: 20),
        _buildActionTeamEfficiencyChart(),
      ],
    );
  }

  Widget _buildIncidentSubtypeChart() {
    // Sample data
    final data = [
      {'type': 'Fire', 'count': 30},
      {'type': 'Injury', 'count': 50},
      {'type': 'Spill', 'count': 20},
    ];
    return _buildChartCard(
      title: 'Tickets by Category',
      child: SfCircularChart(
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        series: <CircularSeries>[
          PieSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (item, _) => item['type'],
            yValueMapper: (item, _) => item['count'],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentLocationChart() {
    final data = [
      {'location': 'Warehouse A', 'count': 40},
      {'location': 'Warehouse B', 'count': 60},
    ];
    return _buildChartCard(
      title: 'Tickets by Location',
      child: SfCircularChart(
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        series: <CircularSeries>[
          DoughnutSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (item, _) => item['location'],
            yValueMapper: (item, _) => item['count'],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTeamEfficiencyChart() {
    final data = [
      {'team': 'Team A', 'efficiency': 80},
      {'team': 'Team B', 'efficiency': 70},
    ];
    return _buildChartCard(
      title: 'Support Team Efficiency',
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <BarSeries>[
          BarSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (item, _) => item['team'],
            yValueMapper: (item, _) => item['efficiency'],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

void handleLogout(BuildContext context) async {
  UserServices userServices = UserServices();
  await userServices.logout();
}
