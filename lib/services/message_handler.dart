import 'package:firebase_messaging/firebase_messaging.dart';

class MessageHandlerService {
  static void handleBackgroundMessage(RemoteMessage message) {
    print('Handling a background message: $message');
  }

  static void printMessage(RemoteMessage message) {
    print('Received message: ${message.toMap()}');
  }
}
