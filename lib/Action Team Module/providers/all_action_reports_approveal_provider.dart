import 'package:flutter/material.dart';


class ApprovalStatusProvider extends ChangeNotifier {
  String _status = '';

  String get status => _status;

  void updateStatus(String newStatus) {
    _status = newStatus;
    notifyListeners();
  }
}

