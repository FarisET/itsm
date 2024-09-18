import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for LengthLimitingTextInputFormatter
import 'package:safify/api/incident_types_data_service.dart';
import 'package:safify/services/toast_service.dart';

class AddIncidentTypePage extends StatefulWidget {
  const AddIncidentTypePage({super.key});

  @override
  State<AddIncidentTypePage> createState() => _AddIncidentTypePageState();
}

class _AddIncidentTypePageState extends State<AddIncidentTypePage> {
  final TextEditingController _incidTypeController = TextEditingController();

  @override
  void dispose() {
    _incidTypeController.dispose();
    super.dispose();
  }

  void _showConfirmationDialog(String IncidentTypeName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogBoxa(
          incidentType: IncidentTypeName,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Incident Type'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning,
                              color: Colors.black,
                              size: 20.0,
                            ),
                            const SizedBox(width: 10.0),
                            Text("New Incident Type Name",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        autofocus: true,
                        controller: _incidTypeController,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'New Incident Type Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    final incidentName = _incidTypeController.text;
                    if (incidentName.isNotEmpty) {
                      _showConfirmationDialog(incidentName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text('Please enter Incident Type name')),
                      );
                    }
                  },
                  child: const Text('Add Incident Type'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlertDialogBoxa extends StatefulWidget {
  final String incidentType;
  AlertDialogBoxa({
    super.key,
    required this.incidentType,
  });

  @override
  State<AlertDialogBoxa> createState() => _AlertDialogBoxState();
}

class _AlertDialogBoxState extends State<AlertDialogBoxa> {
  final IncidentTypesDataService _incidentTypeDataService =
      IncidentTypesDataService();
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: const Text(
        'Confirm Incident Type Addition',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Are you sure you want to add this new Incident Type:'),
          const SizedBox(height: 10.0),
          Text(widget.incidentType,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
          const SizedBox(height: 20.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      isSubmitting = true;
                    });
                    try {
                      // throw Exception(
                      //     'Error adding Incident Type'); // remove this later

                      await _incidentTypeDataService
                          .addIncidentType(widget.incidentType);
                    } catch (e) {
                      setState(() {
                        isSubmitting = false;
                      });
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      ToastService.showCustomSnackBar(
                          context: context,
                          leading: const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.black,
                          ),
                          content: const Text(
                            'Error adding Incident Type',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          textColor: Colors.white);
                      return;
                    }

                    setState(() {
                      isSubmitting = false;
                    });
                    Navigator.of(context)
                        .popUntil((route) => route.isFirst); // final response =
                    // print('Response: $response');
                    ToastService.showCustomSnackBar(
                        context: context,
                        leading: const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Colors.black,
                        ),
                        content: const Text(
                          'Incident Type added successfully.',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white);
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Center(
                      child: isSubmitting
                          ? SizedBox(
                              width: MediaQuery.of(context).size.height * 0.025,
                              height:
                                  MediaQuery.of(context).size.height * 0.025,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Confirm',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
