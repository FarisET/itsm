import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> getDeviceToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  return token!;
}
