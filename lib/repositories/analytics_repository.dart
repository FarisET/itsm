import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/providers/action_team_efficiency_provider.dart';
import 'package:safify/Admin%20Module/providers/analytics_incident_reported_provider.dart';
import 'package:safify/Admin%20Module/providers/analytics_incident_resolved_provider.dart';
import 'package:safify/Admin%20Module/providers/fetch_countOfLocations_provider%20copy.dart';
import 'package:safify/Admin%20Module/providers/fetch_countOfSubtypes_provider.dart';
import 'package:safify/api/analytics_service.dart';
import 'package:safify/db/analytics_db.dart';
import 'package:safify/models/action_team_efficiency.dart';
import 'package:safify/models/count_incidents_by_location.dart';
import 'package:safify/models/count_incidents_by_subtype.dart';
import 'package:safify/services/toast_service.dart';
import 'package:safify/utils/network_util.dart';

class AnalyticsRepository {
  // // Private constructor to prevent direct instantiation
  // AnalyticsRepository._privateConstructor();

  // // Singleton instance
  // static final AnalyticsRepository _instance =
  //     AnalyticsRepository._privateConstructor();

  // // Factory constructor to return the singleton instance
  // factory AnalyticsRepository() {
  //   return _instance;
  // }

  final _analyticsDb = AnalyticsDb();

  Future<int?> fetchTotalIncidentsReportedFromDb() async {
    final totalIncidents =
        await _analyticsDb.getIncidentAnalyticsByName("incidents_reported");
    print(
        "totalIncidents['incident_count'] ${totalIncidents['incident_count']}");
    return totalIncidents['incident_count'];
  }

  Future<int?> fetchTotalIncidentsResolvedFromDb() async {
    final totalIncidents =
        await _analyticsDb.getIncidentAnalyticsByName("incidents_resolved");
    print(
        "totalIncidents['incident_count'] ${totalIncidents['incident_count']}");
    return totalIncidents['incident_count'];
  }

  Future<List<CountByLocation>> fetchIncidentLocationAnalyticsFromDb() async {
    final incidentLocationAnalytics =
        await _analyticsDb.getIncidentLocationAnalytics();

    final list = incidentLocationAnalytics
        .map((json) => CountByLocation.fromJson(json))
        .toList();

    return list;
  }

  Future<List<CountByIncidentSubTypes>>
      fetchIncidentSubtypeAnalyticsFromDb() async {
    final incidentSubtypeAnalytics =
        await _analyticsDb.getIncidentSubtypeAnalytics();

    final list = incidentSubtypeAnalytics
        .map((json) => CountByIncidentSubTypes.fromJson(json))
        .toList();

    return list;
  }

  Future<List<ActionTeamEfficiency>>
      fetchActionTeamEfficiencyAnalyticsFromDb() async {
    final actionTeamEfficiencyAnalytics =
        await _analyticsDb.getEfficiencyAnalytics();

    final list = actionTeamEfficiencyAnalytics
        .map((json) => ActionTeamEfficiency.fromJson(json))
        .toList();

    return list;
  }

  Future<String> updateAnalytics(BuildContext context) async {
    debugPrint("Updating analytics..");

    final ping = await ping_google();
    if (!ping) {
      // ToastService.showCouldNotConnectSnackBar(context);
      return "failed to update analytics";
    }

    final analyticsService = AnalyticsService();
    final json = await analyticsService.fetchAnalytics();

    await _updateIncidentReportedProvider(json["incidentsReported"], context);
    await _updateIncidentResolvedProvider(json["incidentsResolved"], context);

    final List<dynamic> l = json["totalIncidentsOnSubTypes"];
    final List<Map<String, dynamic>> incidentsOnSubTypes =
        l.map((e) => e as Map<String, dynamic>).toList();
    final List<dynamic> r = json["totalIncidentsOnLocations"];
    final List<Map<String, dynamic>> incidentsOnLocation =
        r.map((e) => e as Map<String, dynamic>).toList();
    r.map((e) => print(e));

    final List<dynamic> m = json["efficiency"];
    final List<Map<String, dynamic>> actionTeamEfficiency =
        m.map((e) => e as Map<String, dynamic>).toList();

    await _updateIncidentSubtypeAnalyticsProvider(incidentsOnSubTypes, context);
    await _updateIncidentLocationAnalyticsProvider(
        incidentsOnLocation, context);
    await _updateActionTeamEfficiencyProvider(actionTeamEfficiency, context);

    return "successfully updated analytics from server";
  }

  Future<void> _updateIncidentReportedProvider(int count, context) async {
    await _analyticsDb.insertIncidentAnalytic({
      "analytics_name": "incidents_reported",
      "incident_count": count,
    });

    Provider.of<CountIncidentsReportedProvider>(context, listen: false)
        .getCountReportedPostData();
  }

  Future<void> _updateIncidentResolvedProvider(
      int count, BuildContext context) async {
    await _analyticsDb.insertIncidentAnalytic({
      "analytics_name": "incidents_resolved",
      "incident_count": count,
    });
    await Provider.of<CountIncidentsResolvedProvider>(context, listen: false)
        .getCountResolvedPostData();
  }

  Future<void> _updateIncidentSubtypeAnalyticsProvider(
      List<Map<String, dynamic>> jsonList, BuildContext context) async {
    await _analyticsDb.insertIncidentSubtypeAnalyticsJson(jsonList);

    Provider.of<CountByIncidentSubTypesProviderClass>(context, listen: false)
        .getcountByIncidentSubTypesPostData();
  }

  Future<void> _updateIncidentLocationAnalyticsProvider(
      List<Map<String, dynamic>> jsonList, BuildContext context) async {
    await _analyticsDb.insertIncidentLocationAnalyticsJson(jsonList);

    Provider.of<CountByLocationProviderClass>(context, listen: false)
        .getcountByIncidentLocationPostData();
  }

  Future<void> _updateActionTeamEfficiencyProvider(
      List<Map<String, dynamic>> jsonList, BuildContext context) async {
    await _analyticsDb.insertEfficiencyAnalyticsJson(jsonList);

    Provider.of<ActionTeamEfficiencyProviderClass>(context, listen: false)
        .getactionTeamEfficiencyData();
  }
}
