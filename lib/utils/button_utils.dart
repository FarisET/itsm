import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/Action%20Team%20Module/pages/action_report_form.dart';
import 'package:safify/Action%20Team%20Module/providers/action_reports_provider.dart';
import 'package:safify/Admin%20Module/providers/delete_action_report_provider.dart';
import 'package:safify/models/action_report.dart';
import 'package:safify/models/assign_task.dart';
import 'package:safify/models/user_report.dart';
import 'package:shared_preferences/shared_preferences.dart';

void handleImageButton(String? imageUrl, BuildContext context) {
  if (imageUrl != null) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width:
                MediaQuery.of(context).size.width * 0.7, // 70% of screen width
            height: MediaQuery.of(context).size.height *
                0.7, // 70% of screen width (square box)

            // Limiting the child to the box's size and maintaining aspect ratio
            child: FittedBox(
              fit: BoxFit.contain, // Maintain aspect ratio, fit within the box
              child: CachedNetworkImage(
                imageUrl: '${imageUrl}',
              ),
            ),
          ),
        );
      },
    );
  } else {
    //    Fluttertoast.showToast(msg: 'msg');
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.image_not_supported_outlined,
                      size: 30, color: Colors.black),
                  SizedBox(width: 10),
                  Text('No Image Added',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ],
              )),
        );
      },
    );
  }
}

void startResolution(AssignTask item, BuildContext context) async {
  //Add to Assigned form
  //  Fluttertoast.showToast(msg: '${item.id}');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // //                                        if (item != null && item.user_id != null) {
  //                                           if(item.user_id != null)  {
  //                                            await prefs.setString("this_user_id", (item.user_id!));
  //                                           }
  if (item.user_report_id != null) {
    await prefs.setInt("user_report_id", (item.user_report_id!));
    print('user_report_id: ${prefs.getInt("user_report_id")}');
  }

  //                          if(prefs.getString('user_id') !=null && prefs.getInt('user_report_id') !=null) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ActionReportForm()),
  );
  //                           }
  // print('user_id: ${prefs.getString('this_user_id')}');
  // print('id: ${item.id}');
}
