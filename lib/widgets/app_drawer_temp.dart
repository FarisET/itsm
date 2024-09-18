import 'package:flutter/material.dart';
import 'package:safify/models/action_team_efficiency.dart';
import 'package:safify/models/count_incidents_by_location.dart';
import 'package:safify/models/count_incidents_by_subtype.dart';

class AppDrawerTemp extends StatelessWidget {
  final String totalIncidentsReported;
  final String totalIncidentsResolved;
  final List<CountByIncidentSubTypes>? incidentSubtypeBreakdown;
  final List<CountByLocation>? incidentLocationBreakdown;
  final List<ActionTeamEfficiency>? actionTeamEfficiencyBreakdown;
  AppDrawerTemp({
    required this.totalIncidentsReported,
    required this.totalIncidentsResolved,
    required this.incidentSubtypeBreakdown,
    required this.incidentLocationBreakdown,
    required this.actionTeamEfficiencyBreakdown,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Reporting Analytics',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
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
                  Icons.personal_injury,
                  color: Colors.blue,
                  size: 31,
                ),
                title: const Text('Total Incidents Reported'),
                trailing: CircleAvatar(
                    maxRadius: 16, child: Text(totalIncidentsReported)),
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
                  color: Colors.blue,
                  size: 31,
                ),
                title: const Text('Total Incidents Resolved'),
                trailing: CircleAvatar(
                    maxRadius: 16, child: Text(totalIncidentsResolved)),
              ),
            ),
          ),
          Padding(
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
                            color: Colors.blue,
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
                        child: ListView.separated(
                          itemCount: incidentSubtypeBreakdown!.length,
                          itemBuilder: (context, index) {
                            var item = incidentSubtypeBreakdown?[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              leading: const Icon(
                                Icons.arrow_forward_ios,
                              ),
                              title: Text(
                                '${item?.incident_subtype_description}',
                                style: const TextStyle(),
                              ),
                              trailing: CircleAvatar(
                                maxRadius: 12,
                                child: Text(
                                  '${item?.incident_count}',
                                  style: const TextStyle(),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      )
                    ],
                  ),
                )),
          ),
          Padding(
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
                            color: Colors.blue,
                            size: 31,
                          ),
                          Text(
                            'Incidents breakdown by location',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text('')
                        ],
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView.separated(
                          itemCount: incidentLocationBreakdown!.length,
                          itemBuilder: (context, index) {
                            var item = incidentLocationBreakdown?[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              leading: const Icon(
                                Icons.arrow_forward_ios,
                              ),
                              title: Text(
                                '${item?.location_name}',
                                style: const TextStyle(),
                              ),
                              trailing: CircleAvatar(
                                maxRadius: 12,
                                child: Text(
                                  '${item?.incident_count}',
                                  style: const TextStyle(),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      )
                    ],
                  ),
                )),
          ),
          Padding(
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
                            color: Colors.blue,
                            size: 31,
                          ),
                          Text(
                            'Action team Efficiences',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text('')
                        ],
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView.separated(
                          itemCount: actionTeamEfficiencyBreakdown!.length,
                          itemBuilder: (context, index) {
                            var item = actionTeamEfficiencyBreakdown?[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              leading: const Icon(
                                Icons.arrow_forward_ios,
                              ),
                              title: Text(
                                '${item?.action_team_name}',
                                style: const TextStyle(),
                              ),
                              trailing: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.blue,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${item?.efficiency_value}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
