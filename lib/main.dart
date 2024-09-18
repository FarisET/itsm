import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/admin_pages/create_user_form.dart';
import 'package:safify/Admin%20Module/providers/action_team_efficiency_provider.dart';
import 'package:safify/Admin%20Module/providers/all_action_team_provider.dart';
import 'package:safify/Admin%20Module/providers/announcement_provider.dart';
import 'package:safify/Admin%20Module/providers/delete_action_report_provider.dart';
import 'package:safify/Admin%20Module/providers/delete_user_report_provider.dart';
import 'package:safify/Admin%20Module/providers/fetch_countOfLocations_provider%20copy.dart';
import 'package:safify/User%20Module/pages/home_page.dart';
import 'package:safify/User%20Module/pages/splash_screen.dart';
import 'package:safify/db/background_task_manager.dart';
import 'package:safify/services/UserServices.dart';
import 'package:safify/services/message_handler.dart';
import 'package:safify/services/notification_services.dart';
import 'package:safify/widgets/terms_and_conditions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Action Team Module/pages/action_team_home_page.dart';
import 'Action Team Module/providers/all_action_reports_approveal_provider.dart';
import 'Action Team Module/providers/action_reports_provider.dart';
import 'Action Team Module/providers/assigned_tasks_provider.dart';
import 'Admin Module/admin_pages/admin_home_page.dart';
import 'Admin Module/providers/action_team_provider.dart';
import 'Admin Module/providers/analytics_incident_reported_provider.dart';
import 'Admin Module/providers/analytics_incident_resolved_provider.dart';
import 'Admin Module/providers/department_provider.dart';
import 'Admin Module/providers/admin_user_reports_provider.dart';
import 'Admin Module/providers/fetch_countOfSubtypes_provider.dart';
import 'User Module/pages/login_page.dart';
import 'User Module/pages/user_form.dart';
import 'User Module/providers/user_reports_provider.dart';
import 'User Module/providers/incident_subtype_provider.dart';
import 'User Module/pages/error_page.dart';
import 'User Module/providers/incident_type_provider.dart';
import 'User Module/providers/location_provider.dart';
import 'User Module/providers/sub_location_provider.dart';
import 'animations/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the notifications plugin
  // Notifications notifications = Notifications();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? acceptedTerms = prefs.getBool('acceptedTerms');

  // Initialize and register periodic tasks
  final backgroundTaskManager = BackgroundTaskManager();
  await backgroundTaskManager.initializeWorkManager();
  backgroundTaskManager.registerSyncUserFormTask();
  backgroundTaskManager.registerSyncActionFormTask();

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // await Notifications.initialize(flutterLocalNotificationsPlugin);

  // var androidInitSettings =
  //     AndroidInitializationSettings('@mipmap/ic_launcher');
  // var iosinitSettings = DarwinInitializationSettings();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //
  final notificationServices = NotificationServices();
  await notificationServices.requestNotificationPermission();
  notificationServices.firebaseMessagingInit();
  FirebaseMessaging.onBackgroundMessage(_handleBGMessage);

  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission for notifications
  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );

  // Update notification presentation options for foreground messages
  // await messaging.setForegroundNotificationPresentationOptions(
  //   alert: true, // Display an alert notification
  //   badge: true, // Update the app's badge
  //   sound: true, // Play a sound for the notification
  // );

  // print('User granted permission: ${settings.authorizationStatus}');

  // RemoteMessage? initialMessage = await messaging.getInitialMessage();
  // if (initialMessage != null) {
  //   handleNotificationMessage(initialMessage);
  // }

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // await FirebaseMessaging.instance.setAutoInitEnabled(true);

  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.requestPermission();

  UserServices userServices = UserServices();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // Ensure WidgetsBinding is initialized
  String? userId = prefs.getString("user_id");
  // String? userRole = prefs.getString("role");
  String? userRole = await userServices.getRole();
  Widget initialScreen;
//user time parameter or token
  if (acceptedTerms == null || !acceptedTerms) {
    initialScreen = TermsAndConditionsPage();
  } else if (userId != null && userRole != null) {
    if (userRole == "admin") {
      initialScreen = const AdminHomePage();
    } else if (userRole == "user") {
      initialScreen = const HomePage2();
    } else if (userRole == "action_team") {
      initialScreen = const ActionTeamHomePage();
    } else {
      initialScreen =
          const LoginPage(); // Handle the case where the role is not available
    }
  } else {
    initialScreen =
        const LoginPage(); // Handle the case where user session does not exist
  }

  runApp(MyApp(initialScreen: initialScreen));
  // runApp(DevicePreview(
  //   enabled: true,
  //   builder: (BuildContext context) => MyApp(
  //     initialScreen: initialScreen,
  //   ),
  // ));
}

Future<void> _handleBGMessage(RemoteMessage message) async {
  MessageHandlerService.printMessage(message);
  MessageHandlerService.handleBackgroundMessage(message);
}

// void handleNotificationMessage(RemoteMessage message) {
//   // Your notification handling logic here
//   // print('Message data: ${message.data}');
//   if (message.notification != null) {
//     // print('Message also contained a notification: ${message.notification}');
//   }
// }

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//  Notifications notifications = Notifications();
//   await Firebase.initializeApp();
//   Notifications.showNotification(
//       message); // Show notification when in background
// }

customAnimations animate = customAnimations();

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.initialScreen});

  final Widget? initialScreen;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<IncidentProviderClass>(
            create: (context) => IncidentProviderClass()),
        ChangeNotifierProvider<SubIncidentProviderClass>(
            create: (context) => SubIncidentProviderClass()),
        ChangeNotifierProvider<LocationProvider>(
            create: (context) => LocationProvider()),
        ChangeNotifierProvider<SubLocationProviderClass>(
            create: (context) => SubLocationProviderClass()),
        ChangeNotifierProvider<DepartmentProviderClass>(
            create: (context) => DepartmentProviderClass()),
        ChangeNotifierProvider<ActionTeamProviderClass>(
            create: (context) => ActionTeamProviderClass()),
        ChangeNotifierProvider<UserReportsProvider>(
            create: (context) => UserReportsProvider()),
        ChangeNotifierProvider<AdminUserReportsProvider>(
            create: (context) => AdminUserReportsProvider()),
        ChangeNotifierProvider<AssignedTasksProvider>(
            create: (context) => AssignedTasksProvider()),
        ChangeNotifierProvider<ActionReportsProvider>(
            create: (context) => ActionReportsProvider()),
        ChangeNotifierProvider<ApprovalStatusProvider>(
            create: (context) => ApprovalStatusProvider()),
        ChangeNotifierProvider<CountIncidentsResolvedProvider>(
            create: (context) => CountIncidentsResolvedProvider()),
        ChangeNotifierProvider<CountIncidentsReportedProvider>(
            create: (context) => CountIncidentsReportedProvider()),
        ChangeNotifierProvider<CountByIncidentSubTypesProviderClass>(
            create: (context) => CountByIncidentSubTypesProviderClass()),
        ChangeNotifierProvider<CountByLocationProviderClass>(
            create: (context) => CountByLocationProviderClass()),
        ChangeNotifierProvider<ActionTeamEfficiencyProviderClass>(
            create: (context) => ActionTeamEfficiencyProviderClass()),
        ChangeNotifierProvider<DeleteUserReportProvider>(
            create: (context) => DeleteUserReportProvider()),
        ChangeNotifierProvider<DeleteActionReportProvider>(
            create: (context) => DeleteActionReportProvider()),
        ChangeNotifierProvider<AllActionTeamProviderClass>(
            create: (context) => AllActionTeamProviderClass()),
        ChangeNotifierProvider<AllActionTeamProviderClass>(
            create: (context) => AllActionTeamProviderClass()),
        ChangeNotifierProvider<AnnouncementProvider>(
            create: (context) => AnnouncementProvider())
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData(
          useMaterial3: false,
          primarySwatch: Colors.blue,
          secondaryHeaderColor: Colors.grey.shade800,
          hintColor: Color.fromARGB(255, 204, 204, 204),
          scaffoldBackgroundColor: Colors.grey.shade200,

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            titleLarge:
                GoogleFonts.roboto(fontSize: 24, color: Colors.grey.shade800),
            titleMedium: GoogleFonts.roboto(),
            bodyLarge: GoogleFonts.openSans(),
            bodyMedium: GoogleFonts.openSans(),
            bodySmall: GoogleFonts.roboto(),
            displaySmall: GoogleFonts.roboto(),
          ),

          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.grey.shade800,
          ),

          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: _customPageTransitionBuilder(),
              TargetPlatform.iOS: _customPageTransitionBuilder(),
            },
          ),
        ),
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) =>
                const ErrorPage(), // Replace with your error handling page
          );
        },
        home: SplashScreen(
          initalWidget: initialScreen!,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/home_page': (context) => const HomePage2(),
          '/form_page': (context) => const UserForm(),
          '/admin_home_page': (context) => const AdminHomePage(),
          '/action_team_home_page': (context) => const ActionTeamHomePage(),
          '/create_user_form': (context) => const CreatUserForm()
        },
      ),
    );
  }
}

PageTransitionsBuilder _customPageTransitionBuilder() {
  return const _CustomPageTransitionsBuilder();
}

class _CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  const _CustomPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Implement your custom page transition animation here
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(5, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
