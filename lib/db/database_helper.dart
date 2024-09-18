import 'package:flutter/material.dart';
import 'package:safify/models/action_report.dart';
import 'package:safify/models/action_report_form_details.dart';
import 'package:safify/models/assign_task.dart';
import 'package:safify/models/incident_sub_type.dart';
import 'package:safify/models/incident_types.dart';
import 'package:safify/models/location.dart';
import 'package:safify/models/sub_location.dart';
import 'package:safify/models/user_report.dart';
import 'package:safify/models/user_report_form_details.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    print("initializing database...");
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'locations.db');

    // print("deleting database...");
    // await deleteDatabase(path);
    // print("deleted database.");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print("creating db for the first time..");
        await db.execute(
          "CREATE TABLE user_info(id INTEGER PRIMARY KEY, last_login_user_id TEXT)",
        );

        await db.insert(
          'user_info',
          {'id': 0, 'last_login_user_id': null},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        await db.execute(
          'CREATE TABLE locations(location_id TEXT PRIMARY KEY, location_name TEXT)',
        );
        await db.execute(
          'CREATE TABLE sublocations(sub_location_id TEXT PRIMARY KEY, location_id TEXT, sub_location_name TEXT, FOREIGN KEY (location_id) REFERENCES locations (location_id))',
        );

        // make tables for incident types and subtypes
        await db.execute(
          'CREATE TABLE incident_types(incident_type_id TEXT PRIMARY KEY, incident_type_description TEXT)',
        );

        await db.execute(
          'CREATE TABLE incident_subtypes(incident_subtype_id TEXT PRIMARY KEY, incident_type_id TEXT, incident_subtype_description TEXT, FOREIGN KEY (incident_type_id) REFERENCES incident_types (incident_type_id))',
        );
        await db.execute('''
          CREATE TABLE user_form_reports (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            sublocationId TEXT NOT NULL,
            incidentSubtypeId TEXT NOT NULL,
            description TEXT NOT NULL,
            date TEXT NOT NULL,
            criticalityId TEXT NOT NULL,
            imagePath TEXT
          ) 
          ''');

        await db.execute('''
            CREATE TABLE action_form_reports (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              reportedBy TEXT NOT NULL,
              incidentDesc TEXT NOT NULL,
              rootCause1 TEXT,
              rootCause2 TEXT,
              rootCause3 TEXT,
              rootCause4 TEXT,
              rootCause5 TEXT,
              resolutionDesc TEXT NOT NULL,
              incidentSiteImgPath TEXT,
              workProofImgPath TEXT NOT NULL,
              userReportId INTEGER NOT NULL
            )
          ''');

        await db.execute('''
            CREATE TABLE assign_tasks (
              assigned_tasks_id INTEGER PRIMARY KEY ,
              user_report_id INTEGER,
              report_description TEXT,
              date_of_assignment TEXT,
              sub_location_name TEXT,
              incident_subtype_description TEXT,
              image TEXT,
              incident_criticality_level TEXT,
              status TEXT
            )
          ''');
        await db.execute('''
            CREATE TABLE admin_user_reports (
              user_report_id INTEGER PRIMARY KEY,
              user_id TEXT,
              report_description TEXT,
              date_time TEXT,
              sub_location_name TEXT,
              sub_location_id TEXT,
              incident_subtype_description TEXT,
              incident_criticality_level TEXT,
              incident_criticality_id TEXT,
              image TEXT,
              status TEXT
            )
          ''');

        await db.execute('''
            CREATE TABLE admin_action_reports (
              action_report_id INTEGER PRIMARY KEY,
              action_team_name TEXT,
              user_report_id INTEGER,
              report_description TEXT,
              question_one TEXT,
              question_two TEXT,
              question_three TEXT,
              question_four TEXT,
              question_five TEXT,
              resolution_description TEXT,
              reported_by TEXT,
              proof_image TEXT,
              surrounding_image TEXT,
              date_time TEXT,
              status TEXT,
              incident_subtype_description TEXT
            )
        ''');

        await db.execute('''
            CREATE TABLE user_reports (
              user_report_id INTEGER PRIMARY KEY,
              user_id TEXT,
              report_description TEXT,
              date_time TEXT,
              sub_location_name TEXT,
              sub_location_id TEXT,
              incident_subtype_description TEXT,
              incident_criticality_level TEXT,
              incident_criticality_id TEXT,
              image TEXT,
              status TEXT
            )
          ''');

        await db.execute('''
            CREATE TABLE times (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              time TEXT
            )
        ''');

        await db.execute('''
            CREATE TABLE incident_analytics (
              analytics_name TEXT PRIMARY KEY,
              incident_count INTEGER
            )
        ''');

        await db.execute('''
            CREATE TABLE action_team_efficiency_analytics (
              action_team_name TEXT PRIMARY KEY,
              efficiency_value REAL
            )
        ''');

        await db.execute('''
            CREATE TABLE incident_subtype_analytics (
              incident_subtype_description TEXT PRIMARY KEY,
              incident_count INTEGER
            )
        ''');

        await db.execute('''
            CREATE TABLE incident_location_analytics (
              location_name TEXT PRIMARY KEY,
              incident_count INTEGER
            )
        ''');
      },
    );
  }

  Future<void> setLastUserId(String userId) async {
    final db = await database;
    final userInfo = {"id": 0, "last_login_user_id": userId};
    db.insert(
      "user_info",
      userInfo,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>> getLastUserId() async {
    final db = await database;
    ;
    final List<Map<String, dynamic>> map =
        await db.query('user_info', where: 'id = ?', whereArgs: [0]);
    return map[0];
  }

  Future<List<Map<String, dynamic>>> getAllUserReports() async {
    final db = await database;
    final List<Map<String, dynamic>> map = await db.query('user_form_reports');
    return map;
  }

  Future<void> clearDBdata() async {
    debugPrint("Clearing database...");

    final db = await database;
    await db.delete('admin_user_reports');
    await db.delete('admin_action_reports');

    await db.delete('assign_tasks');
    await db.delete('user_reports');

    await db.delete('user_form_reports');
    await db.delete('action_form_reports');

    debugPrint("Cleared database.");

    // var list = await getAdminActionReports();
    // print("admin action reports: $list");
    // list = await getAdminUserReports();
    // print("admin user reports: $list");
    // // list = await getAdminActionReports();
    // print("assign tasks: $list");
    // list = await getUserReports();
    // print("user reports: $list");

    // var list2 = await getActionFormReports();
    // print("action form reports: $list");
    // var list3 = await getUserFormReports();
    // print("user form reports: $list");
  }

  Future<void> insertUserReportsJson(
      List<Map<String, dynamic>> userReports) async {
    final db = await database;
    Batch batch = db.batch();

    for (var userReport in userReports) {
      batch.insert(
        'user_reports',
        // for safety, as json can have extra fields which are not columns in table
        UserReport.fromJson(userReport).toJson(),

        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getUserReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('user_reports', orderBy: "date_time DESC");
    return maps;
  }

  Future<void> insertAdminUserReportsJson(
      List<Map<String, dynamic>> reports) async {
    final db = await database;
    Batch batch = db.batch();

    for (var report in reports) {
      batch.insert(
        'admin_user_reports',
        UserReport.fromJson(report).toJson(),
        // report,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getAdminActionReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('admin_action_reports', orderBy: "date_time DESC");
    return maps;
  }

  Future<void> insertAdminActionReportsJson(
      List<Map<String, dynamic>> reports) async {
    final db = await database;
    Batch batch = db.batch();

    for (var report in reports) {
      batch.insert(
        'admin_action_reports',
        // report,
        ActionReport.fromJson(report).toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getAdminUserReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('admin_user_reports', orderBy: "date_time DESC");

    return maps;
  }

  Future<bool> deleteAdminUserReport(int userReportId) async {
    final db = await database;
    final int result = await db.delete(
      'admin_user_reports',
      where: 'user_report_id = ?',
      whereArgs: [userReportId],
    );
    return result == 1;
  }

  Future<bool> deleteAdminActionReport(int actionReportId) async {
    final db = await database;
    final int result = await db.delete(
      'admin_action_reports',
      where: 'action_report_id = ?',
      whereArgs: [actionReportId],
    );
    return result == 1;
  }

  Future<int> clearTable(String tableName) async {
    final db = await database;
    final int result = await db.delete(tableName);
    return result;
  }

  Future<void> insertAssignTasks(List<AssignTask> assignTasks) async {
    final db = await database;
    Batch batch = db.batch();

    for (var assignTask in assignTasks) {
      batch.insert(
        'assign_tasks',
        assignTask.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> insertAssignTasksJson(
      List<Map<String, dynamic>> assignTasks) async {
    final db = await database;
    Batch batch = db.batch();

    for (var assignTask in assignTasks) {
      batch.insert(
        'assign_tasks',
        AssignTask.fromJson(assignTask).toJson(), //change this
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<AssignTask>> getAllAssignTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('assign_tasks', orderBy: "date_of_assignment DESC");
    return List.generate(maps.length, (i) {
      return AssignTask.fromJson(maps[i]);
    });
  }

  Future<int> insertTime(String time) async {
    final db = await database;
    return await db.insert('times', {'time': time});
  }

  Future<List<Map<String, dynamic>>> queryAllTimes() async {
    final db = await database;
    return await db.query('times');
  }

  Future<void> insertUserFormReport(
      UserReportFormDetails userReportFormDetails) async {
    final db = await database;
    await db.insert(
      'user_form_reports',
      userReportFormDetails.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<int, UserReportFormDetails>> getUserFormReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_form_reports');
    return {
      for (var item in maps) item['id']: UserReportFormDetails.fromJson(item)
    };
  }

  Future<void> deleteUserFormReport(int id) async {
    final db = await database;
    await db.delete(
      'user_form_reports',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertActionFormReport(
      ActionReportFormDetails actionReportFormDetails) async {
    final db = await database;
    return await db.insert(
      'action_form_reports',
      actionReportFormDetails.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>> getActionFormReport(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'action_form_reports',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.first;
  }

  Future<Map<int, ActionReportFormDetails>> getActionFormReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('action_form_reports');
    return {
      for (var item in maps) item['id']: ActionReportFormDetails.fromJson(item)
    };
  }

  Future<void> deleteActionFormReport(int id) async {
    final db = await database;
    await db.delete(
      'action_form_reports',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Batch insert for multiple locations and sublocations
  Future<void> insertLocationsAndSublocations(
      List<Location> locations, List<SubLocation> sublocations) async {
    final db = await database;
    Batch batch = db.batch();

    for (var location in locations) {
      batch.insert(
        'locations',
        location.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    for (var sublocation in sublocations) {
      batch.insert(
        'sublocations',
        sublocation.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> insertIncidentAndSubincidentTypes(
      List<IncidentType> incidentTypes,
      List<IncidentSubType> incidentSubTypes) async {
    final db = await database;
    Batch batch = db.batch();

    for (var incidentType in incidentTypes) {
      batch.insert(
        'incident_types',
        incidentType.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    for (var incidentSubType in incidentSubTypes) {
      batch.insert(
        'incident_subtypes',
        incidentSubType.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> insertLocation(Location location) async {
    final db = await database;
    await db.insert(
      'locations',
      location.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertSublocation(SubLocation sublocation) async {
    final db = await database;
    await db.insert(
      'sublocations',
      sublocation.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Location>> getLocations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('locations');
    return List.generate(maps.length, (i) {
      return Location.fromJson(maps[i]);
    });
  }

  Future<List<SubLocation>> getAllSubLocations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sublocations');
    return List.generate(maps.length, (i) {
      return SubLocation.fromJson(maps[i], maps[i]['location_id']);
    });
  }

  Future<List<SubLocation>> getSublocations(String locationId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sublocations',
      where: 'location_id = ?',
      whereArgs: [locationId],
    );
    return List.generate(maps.length, (i) {
      return SubLocation.fromJson(maps[i], locationId);
    });
  }

  Future<List<IncidentType>> getIncidentTypes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('incident_types');
    return List.generate(maps.length, (i) {
      return IncidentType.fromJson(maps[i]);
    });
  }

  Future<List<IncidentSubType>> getAllIncidentSubtypes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('incident_subtypes');
    return List.generate(maps.length, (i) {
      return IncidentSubType.fromJson(maps[i], maps[i]['incident_type_id']);
    });
  }

  Future<void> updateLocation(Location location) async {
    final db = await database;
    await db.update(
      'locations',
      location.toJson(),
      where: 'location_id = ?',
      whereArgs: [location.locationId],
    );
  }

  Future<void> updateSublocation(SubLocation sublocation) async {
    final db = await database;
    await db.update(
      'sublocations',
      sublocation.toJson(),
      where: 'sublocation_id = ?',
      whereArgs: [sublocation.sublocationId],
    );
  }

  Future<void> deleteLocation(String id) async {
    final db = await database;

    await db.delete(
      'locations',
      where: 'location_id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteSublocation(String id) async {
    final db = await database;
    await db.delete(
      'sublocations',
      where: 'sublocation_id = ?',
      whereArgs: [id],
    );
  }
}
