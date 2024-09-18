import 'package:sqflite/sqflite.dart';
import 'package:safify/db/database_helper.dart';

class AnalyticsDb {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertEfficiencyAnalyticsJson(
      List<Map<String, dynamic>> jsonList) async {
    final db = await _databaseHelper.database;
    Batch batch = db.batch();

    for (var json in jsonList) {
      batch.insert(
        'action_team_efficiency_analytics',
        json,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  Future<void> insertIncidentSubtypeAnalyticsJson(
      List<Map<String, dynamic>> jsonList) async {
    final db = await _databaseHelper.database;
    Batch batch = db.batch();

    for (var json in jsonList) {
      batch.insert(
        'incident_subtype_analytics',
        json,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  Future<void> insertIncidentLocationAnalyticsJson(
      List<Map<String, dynamic>> jsonList) async {
    final db = await _databaseHelper.database;
    Batch batch = db.batch();

    for (var json in jsonList) {
      batch.insert(
        'incident_location_analytics',
        json,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<void> insertIncidentAnalyticsJson(
      List<Map<String, dynamic>> jsonList) async {
    final db = await _databaseHelper.database;
    Batch batch = db.batch();

    for (var json in jsonList) {
      batch.insert(
        'incident_analytics',
        json,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<void> insertIncidentAnalytic(Map<String, dynamic> json) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'incident_analytics',
      json,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getEfficiencyAnalytics() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('action_team_efficiency_analytics');
    return maps;
  }

  Future<List<Map<String, dynamic>>> getIncidentSubtypeAnalytics() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('incident_subtype_analytics');
    return maps;
  }

  Future<List<Map<String, dynamic>>> getIncidentLocationAnalytics() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('incident_location_analytics');
    return maps;
  }

  Future<List<Map<String, dynamic>>> getIncidentAnalytics() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('incident_analytics');
    return maps;
  }

  Future<Map<String, dynamic>> getIncidentAnalyticsByName(
      String analyticsName) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'incident_analytics',
      where: 'analytics_name = ?',
      whereArgs: [analyticsName],
    );

    if (maps.isEmpty) {
      return {};
    }

    return maps.first;
  }
}
