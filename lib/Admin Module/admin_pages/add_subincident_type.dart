import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for LengthLimitingTextInputFormatter
import 'package:provider/provider.dart';
import 'package:safify/User%20Module/providers/incident_type_provider.dart';
import 'package:safify/api/incident_types_data_service.dart';
import 'package:safify/services/toast_service.dart';

class AddSubIncidentTypePage extends StatefulWidget {
  const AddSubIncidentTypePage({super.key});

  @override
  State<AddSubIncidentTypePage> createState() => _AddSubIncidentTypePageState();
}

class _AddSubIncidentTypePageState extends State<AddSubIncidentTypePage> {
  final TextEditingController _subtypeController = TextEditingController();
  final TextEditingController _incdentTypeController = TextEditingController();
  String? _selectedIncidentName;
  String? _selectedIncidentId;

  @override
  void dispose() {
    _subtypeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Provider.of<IncidentProviderClass>(context, listen: false)
        .syncDbAndFetchIncidentTypes();
  }

  void _showConfirmationDialog(
      String incidentId, String subincidentName, String incidentName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SubIncidentAlertDialogBox(
          incidentId: incidentId,
          incidentName: incidentName,
          subincidentName: subincidentName,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final incidentTypesProvider = Provider.of<IncidentProviderClass>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add SubIncident Type'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_rounded,
                            color: Colors.black,
                            size: 20.0,
                          ),
                          const SizedBox(width: 10.0),
                          Flexible(
                            child: Text("Select Incident Type",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    DropdownMenu(
                        inputDecorationTheme: InputDecorationTheme(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        menuStyle: MenuStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                        ),
                        expandedInsets:
                            const EdgeInsets.symmetric(horizontal: 0.0),
                        requestFocusOnTap: true,
                        menuHeight: MediaQuery.sizeOf(context).height * 0.3,
                        label: const Text("Select Incident Type"),
                        controller: _incdentTypeController,
                        enableFilter: true,
                        enableSearch: true,
                        onSelected: (value) {
                          setState(() {
                            _selectedIncidentId = value;
                            _selectedIncidentName =
                                _incdentTypeController.text.isEmpty
                                    ? null
                                    : _incdentTypeController.text;
                          });
                          _subtypeController.clear();
                        },
                        dropdownMenuEntries: [
                          const DropdownMenuEntry(
                            labelWidget: Text(
                              "Select Incident Type",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic),
                            ),
                            label: "",
                            value: null,
                          ),
                          ...incidentTypesProvider.incidentTypes!
                              .map((incidentType) {
                            return DropdownMenuEntry(
                              label: incidentType.incidentTypeDescription,
                              value: incidentType.incidentTypeId,
                            );
                          }).toList()
                        ]),
                    const SizedBox(height: 20),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RichText(
                            text: TextSpan(
                              text: 'Selected Incident Type: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors
                                    .black, // You can specify the color if needed
                              ),
                              children: [
                                TextSpan(
                                  text: _selectedIncidentName ?? 'None',
                                  style: const TextStyle(
                                    fontWeight: FontWeight
                                        .normal, // Change the style for the
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    // const SizedBox(height: 20.0),
                    // Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(left: 8.0),
                    //       child: RichText(
                    //         text: TextSpan(
                    //           text: 'Selected Incident Type ID: ',
                    //           style: const TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 16.0,
                    //             color: Colors
                    //                 .black, // You can specify the color if needed
                    //           ),
                    //           children: [
                    //             TextSpan(
                    //               text: _selectedIncidentId ?? 'None',
                    //               style: const TextStyle(
                    //                 fontWeight: FontWeight.normal,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     )),
                    const SizedBox(height: 40.0),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            _selectedIncidentId == null
                                ? Icons.info_outline
                                : Icons.info,
                            color: _selectedIncidentName == null
                                ? Colors.grey
                                : Colors.black,
                            size: 20.0,
                          ),
                          const SizedBox(width: 10.0),
                          Flexible(
                            child: Text("Select New Incident Subtype Name",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: _selectedIncidentId == null
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                  color: _selectedIncidentId == null
                                      ? Colors.grey
                                      : Colors.black,
                                )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      enabled: _selectedIncidentName != null,
                      controller: _subtypeController,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {},
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50),
                      ],
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: _selectedIncidentId != null,
                        alignLabelWithHint: true,
                        hintText: _selectedIncidentId == null
                            ? 'Select an Incident Type first'
                            : 'Enter Incident Subtype Name',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                  ],
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
                    final incidentSubtype = _subtypeController.text;
                    if (_selectedIncidentName != null &&
                        incidentSubtype.isNotEmpty) {
                      _showConfirmationDialog(_selectedIncidentId!,
                          incidentSubtype, _selectedIncidentName!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                              'Please select an Incident Type and enter Incident Subtype name')));
                    }
                  },
                  child: const Text('Add Incident Subtype'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubIncidentAlertDialogBox extends StatefulWidget {
  final String incidentId;
  final String incidentName;
  final String subincidentName;
  SubIncidentAlertDialogBox({
    super.key,
    required this.incidentId,
    required this.incidentName,
    required this.subincidentName,
  });

  @override
  State<SubIncidentAlertDialogBox> createState() =>
      _SubIncidentAlertDialogBoxState();
}

class _SubIncidentAlertDialogBoxState extends State<SubIncidentAlertDialogBox> {
  final IncidentTypesDataService _incidentTypeDataService =
      IncidentTypesDataService();
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: const Text('Confirm SubIncident Type Addition'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Are you sure you want to add this new Incident SubType:'),
          const SizedBox(height: 20.0),
          Center(
            child: Text(widget.subincidentName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0)),
          ),
          const SizedBox(height: 20.0),
          RichText(
              text: TextSpan(
            text: 'To the Incident Type: ',
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: widget.incidentName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
          const SizedBox(height: 10.0),
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
                      //     'Error adding Incident Subtype'); // remove this later

                      final response =
                          await _incidentTypeDataService.addIncidentSubType(
                              widget.subincidentName, widget.incidentId);
                    } catch (e) {
                      setState(() {
                        isSubmitting = false;
                      });

                      Navigator.of(context).popUntil(
                          (route) => route.isFirst); // final response =
                      ToastService.showCustomSnackBar(
                          context: context,
                          leading: const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.black,
                          ),
                          content: const Text(
                            'An error occurred while adding Incident SubType.',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          textColor: Colors.white);
                      return;
                    }

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
                          'Incident SubType added successfully.',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white);
                    setState(() {
                      isSubmitting = false;
                    });
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
