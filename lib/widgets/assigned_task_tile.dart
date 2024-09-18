import 'dart:math';

import 'package:flutter/material.dart';
import 'package:safify/components/custom_button.dart';
import 'package:safify/models/assign_task.dart';
import 'package:safify/utils/button_utils.dart';
import 'package:safify/utils/string_utils.dart';

class AssignedTaskTile extends StatelessWidget {
  final AssignTask task;
  const AssignedTaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        // color: item.status!.contains('open')
        //     ? Colors.red[50]
        //     : (item.status!.contains('in progress')
        //         ? Colors.orange[50]
        //         : Colors.green[50]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // side: BorderSide(
        //   // color: item.status!.contains('open')?Colors.redAccent:Colors.greenAccent,
        //    width:1)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "${task.incident_subtype_description!}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.04,
                          ),
                          Text(
                              '${capitalizeFirstLetter(task.incident_criticality_level)}',
                              style: TextStyle(
                                  color: task.incident_criticality_level!
                                          .contains('minor')
                                      ? Colors.black
                                      : (task.incident_criticality_level!
                                              .contains('serious')
                                          ? Colors.black
                                          : Colors.black),
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: Colors.black, size: 20),
                        Text(' ${task.sub_location_name}')
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.timer_outlined,
                            color: Colors.black, size: 20),
                        Text(
                            ' ${task.date_of_assignment?.split('T')[0]} | ${task.date_of_assignment?.split('T')[1].replaceAll(RegExp(r'\.\d+Z$'), '')}')
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.textsms_outlined,
                            color: Colors.black, size: 20),
                        Expanded(
                          child: Text(
                            ' ${task.report_description}',
                            style: const TextStyle(
                                //  fontSize: 16
                                ),
                          ),
                        )
                      ],
                    ),
                    //TODO: try image
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom:4.0),
                    //   child: Text('By: Faris Ejaz'),
                    // ),
                    //TODO: get user name dynamically
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: !task.status!.contains('approved') &&
                                  !task.status!.contains('approval pending'),
                              child: StartButton(
                                  onTap: () => startResolution(task, context)),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            ImageButton(
                                onTap: () =>
                                    handleImageButton(task.image, context)),
                          ],
                        ),

                        task.status!.contains('assigned')
                            ? const Text('Assigned',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold))
                            : task.status!.contains('approval pending')
                                ? const Text('Approval pending',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold))
                                : Text('${capitalizeFirstLetter(task.status)}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                        //TODO: change status color dynamically
                      ],
                    ),
                  ]),
            ],
          ),
        ));
  }
}
