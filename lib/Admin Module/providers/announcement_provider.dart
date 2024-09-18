import 'package:flutter/widgets.dart';
import 'package:safify/models/announcement_notif.dart';
import 'package:safify/services/notification_services.dart';

class AnnouncementProvider extends ChangeNotifier {
  bool loading = false;

  Future<void> sendAlert(Announcement announce) async {
    loading = true;
    notifyListeners();

    try {
      await NotificationServices.sendAlert(announce);
    } catch (e) {
      throw Exception('Failed to send alert');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
