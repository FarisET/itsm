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

        //AnalyticsRepository().updateAnalytics(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var countResolvedProvider =
        Provider.of<CountIncidentsResolvedProvider>(context)
            .totalIncidentsResolved;
    var countReportedProvider =
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
            _buildStatisticsGrid(
                context, countReportedProvider!, countResolvedProvider!),
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

  Widget _buildStatisticsGrid(
      BuildContext context, String reported, String resolved) {
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
          itemCount: 2,
          itemBuilder: (context, index) {
            final icons = [
              Icons.personal_injury,
              Icons.check_box,
              Icons.category,
              Icons.group
            ];
            final titles = [
              'Tickets this year',
              'Tickets resolved this Year',
            ];
            final counts = [
              reported,
              resolved,
            ];
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
                Icon(icon, color: Theme.of(context).primaryColor, size: 25),
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
    try {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: _buildIncidentTypeTab(
                  context), // Ensure this gets proper height
            ),
          ),
          const SizedBox(height: 20),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child:
                  _buildLocationTab(context), // Ensure this gets proper height
            ),
          ),
          const SizedBox(height: 20),
          _buildActionTeamEfficiencyChart(),
        ],
      );
    } catch (e, stackTrace) {
      print("Error in _buildChartsSection: $e\n$stackTrace");
      return Center(child: Text("Failed to load charts."));
    }
  }

  Widget _buildIncidentTypeTab(BuildContext context) {
    final provider = Provider.of<CountByIncidentSubTypesProviderClass>(context);
    final data = provider.countByIncidentSubTypes;

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data == null || data.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    final filteredData = data
        ?.where((item) =>
            (item.incident_subtype_description != null &&
                item.incident_subtype_description!.isNotEmpty) &&
            (item.incident_count != null && item.incident_count! > 0))
        .toList();
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(icon: Icon(Icons.list), text: 'List View'),
                Tab(icon: Icon(Icons.bar_chart), text: 'Graph View'),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                children: [
                  _buildIncidentTypeListView(context, filteredData!),
                  _buildIncidentTypeGraphView(context, filteredData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentTypeListView(
      BuildContext context, List<CountByIncidentSubTypes> filteredData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Center(
          child: Text(
            'Tickets by Asset Type (${filteredData.length})',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final item = filteredData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      item.incident_subtype_description ?? 'N/A',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        '${item.incident_count ?? 0}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIncidentTypeGraphView(
      BuildContext context, List<CountByIncidentSubTypes> filteredData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ticket trend by Asset Type',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SfCartesianChart(
            tooltipBehavior: TooltipBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              tooltipPosition: TooltipPosition.auto,
            ),
            primaryXAxis: CategoryAxis(
              isVisible: false,
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'Ticket Count'),
            ),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
              alignment: ChartAlignment.center,
            ),
            series: <CartesianSeries>[
              LineSeries<CountByIncidentSubTypes, String>(
                dataSource: filteredData,
                xValueMapper: (item, _) =>
                    item.incident_subtype_description ?? '',
                yValueMapper: (item, _) => item.incident_count ?? 0,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
                color: Colors.blue,
                name: 'Ticket Count',
                markerSettings: MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  color: Colors.black,
                  borderColor: Colors.black,
                  borderWidth: 2,
                  height: 5,
                  width: 5,
                ),
                enableTooltip: true,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Tap on a data point to reveal asset type',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationTab(BuildContext context) {
    final provider = Provider.of<CountByLocationProviderClass>(context);
    final data = provider.countByLocation;

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data == null || data.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    final filteredData = data
        ?.where((item) =>
            (item.incident_count != null && item.location_name!.isNotEmpty) &&
            (item.incident_count != null && item.incident_count! > 0))
        .toList();
    // setState(() {
    //   totalLocations = filteredData!.length.toString();
    // });

    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(icon: Icon(Icons.list), text: 'List View'),
                Tab(icon: Icon(Icons.bar_chart), text: 'Graph View'),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                children: [
                  _buildIncidentLocationListView(context, filteredData!),
                  _buildIncidentLocationGraphView(context, filteredData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentLocationListView(
      BuildContext context, List<CountByLocation> filteredData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Center(
          child: Text(
            'Tickets by Location (${filteredData.length})',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final item = filteredData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      item.location_name ?? 'N/A',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        '${item.incident_count ?? 0}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIncidentLocationGraphView(
      BuildContext context, List<CountByLocation> filteredData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ticket trend by Location',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SfCartesianChart(
            tooltipBehavior: TooltipBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              tooltipPosition: TooltipPosition.auto,
            ),
            primaryXAxis: CategoryAxis(
              isVisible: false,
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'Ticket Count'),
            ),
            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
              alignment: ChartAlignment.center,
            ),
            series: <CartesianSeries>[
              LineSeries<CountByLocation, String>(
                dataSource: filteredData,
                xValueMapper: (item, _) => item.location_name ?? '',
                yValueMapper: (item, _) => item.incident_count ?? 0,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
                color: Colors.blue,
                name: 'Ticket Count',
                markerSettings: MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  color: Colors.black,
                  borderColor: Colors.black,
                  borderWidth: 2,
                  height: 5,
                  width: 5,
                ),
                enableTooltip: true,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Tap on a data point to reveal location',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildActionTeamEfficiencyChart() {
    // Get provider data
    final provider = Provider.of<ActionTeamEfficiencyProviderClass>(context);
    final data = provider.actionTeamEfficiency;
    final filteredData = data
        ?.where((item) =>
            (item.action_team_name != null &&
                item.action_team_name!.isNotEmpty) &&
            (item.efficiency_value != null && item.efficiency_value! != "0"))
        .toList();

    // Check if loading
    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Check if data is null or empty and display a message if needed
    if (data == null || data.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    // Create the chart using the data from provider
    return _buildChartCard(
      title: 'Action Team Efficiency',
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <BarSeries>[
          BarSeries<ActionTeamEfficiency, String>(
            dataSource: filteredData,
            xValueMapper: (item, _) => item.action_team_name ?? '',
            yValueMapper: (item, _) => item.efficiency_value ?? 0,
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

  void handleLogout(BuildContext context) async {
    UserServices userServices = UserServices();
    await userServices.logout();
  }
}
