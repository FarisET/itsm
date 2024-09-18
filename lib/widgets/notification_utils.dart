import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bitmap/bitmap.dart';

class BitmapUtils {
  static Future<Uint8List> getBitmapFromAsset(String path) async {
    final ByteData? bytes = await rootBundle.load(path);
    return bytes!.buffer.asUint8List();
  }
}

class Notifications {
  late FirebaseMessaging firebaseMessaging;
  late Bitmap bitmap;

  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid = const AndroidInitializationSettings(
        '@drawable/ic_launcher'); // Replace with your icon name
    var initializationSettingsIOS =
        DarwinInitializationSettings(); // Use appropriate class based on platform
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> sendNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String title,
      String body) async {
    final largeIconPath =
        await BitmapUtils.getBitmapFromAsset('@drawable/safify_icon');
    final ByteArrayAndroidBitmap largeIcon =
        ByteArrayAndroidBitmap(largeIconPath);
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel id', // Customize channel ID
      'channel name', // Customize channel name
      channelDescription: 'Channel description', // Customize description
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'Ticker',
      icon: '@drawable/safify_icon',
      styleInformation: BigPictureStyleInformation(
        DrawableResourceAndroidBitmap(
            '@drawable/ic_launcher'), // Ensure this icon exists in your drawable directories
        largeIcon: DrawableResourceAndroidBitmap('@drawable/ic_launcher'),
      ),
    );
//android/app/src/main/res/drawable/safify_icon
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(); // Customize iOS details

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    final message = body;
    await flutterLocalNotificationsPlugin.show(
        0, title, message, notificationDetails); // Corrected variable name
  }

  Future<String?> updateTokenToServer() async {
    try {
      await Firebase.initializeApp();

      String? token = await FirebaseMessaging.instance.getToken();
      print("Firebase Messaging Token: $token");

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        // Handle the new token here, if necessary
        print("New Firebase Messaging Token: $newToken");
        // Optionally send the new token to your backend server
      });

      return token;
    } catch (e) {
      print("Error getting Firebase Messaging Token: $e");
      return null;
    }
  }
}
