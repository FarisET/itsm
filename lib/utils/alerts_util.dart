import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class Alerts {
  static void showAlertDialog(BuildContext context, String responseText) {
    if (Platform.isIOS) {
      customAlertWidget(context, responseText, () {});
    } else if (Platform.isAndroid) {
      customAlertDialogAndroid(context, responseText);
    }
  }

  static void customAlertTokenWidget(
    BuildContext context,
    String responseText,
    VoidCallback onClose,
  ) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(
            responseText,
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                "Close",
              ),
              onPressed: () {
                Navigator.pop(context);
                onClose(); // Call the callback to handle the action
              },
            ),
          ],
        ),
      );
    } else if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(responseText),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.pop(context);
                onClose(); // Call the callback to handle the action
              },
            ),
          ],
        ),
      );
    }
  }

  static void customAlertWidget(
      BuildContext context, String responseText, VoidCallback onClose) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(
            responseText,
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                "OK",
              ),
              onPressed: () {
                Navigator.pop(context);
                onClose(); // Call the callback to handle the action
              },
            ),
          ],
        ),
      );
    } else if (Platform.isAndroid) {
      customAlertDialogAndroid(context, responseText);
    }
  }

  static void customAlertDialogAndroid(
      BuildContext context, String responseText) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(responseText),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  static void showLoadingDialog(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => const CupertinoAlertDialog(
          title: Text("Loading..."),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    } else if (Platform.isAndroid) {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevents dismissal by tapping outside
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Loading...'),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
