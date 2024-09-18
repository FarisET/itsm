import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for LengthLimitingTextInputFormatter
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/admin_pages/admin_home_page.dart';
import 'package:safify/User%20Module/providers/location_provider.dart';
import 'package:safify/api/locations_data_service.dart';
import 'package:safify/models/location.dart';
import 'package:safify/services/toast_service.dart';

class AddSublocationPage extends StatefulWidget {
  const AddSublocationPage({super.key});

  @override
  State<AddSublocationPage> createState() => _AddSublocationPageState();
}

class _AddSublocationPageState extends State<AddSublocationPage> {
  final TextEditingController _sublocationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _selectedLocationName;
  String? _selectedLocationId;

  @override
  void dispose() {
    _sublocationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Provider.of<LocationProvider>(context, listen: false).fetchLocations();
    Provider.of<LocationProvider>(context, listen: false)
        .SyncDbAndFetchLocations();
  }

  void _showConfirmationDialog(
      String locationId, String sublocationName, String locationName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SublocationAlertDialogBox(
          locationId: locationId,
          sublocationName: sublocationName,
          locationName: locationName,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationsProvider = Provider.of<LocationProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Sublocation'),
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
                            CupertinoIcons.location_solid,
                            color: Colors.black,
                            size: 20.0,
                          ),
                          const SizedBox(width: 10.0),
                          Text("Select Location",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
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
                        label: const Text("Select Location"),
                        controller: _locationController,
                        enableFilter: true,
                        enableSearch: true,
                        onSelected: (value) {
                          setState(() {
                            _selectedLocationId = value;
                            _selectedLocationName =
                                _locationController.text.isEmpty
                                    ? null
                                    : _locationController.text;
                          });
                          _sublocationController.clear();
                        },
                        dropdownMenuEntries: [
                          const DropdownMenuEntry(
                            labelWidget: Text(
                              "Select Location",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic),
                            ),
                            label: "",
                            value: null,
                          ),
                          ...locationsProvider.allLocations!.map((location) {
                            return DropdownMenuEntry(
                              label: location.locationName,
                              value: location.locationId,
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
                              text: 'Selected Location Name: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors
                                    .black, // You can specify the color if needed
                              ),
                              children: [
                                TextSpan(
                                  text: _selectedLocationName ?? 'None',
                                  style: const TextStyle(
                                    fontWeight: FontWeight
                                        .normal, // Change the style for the location name
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
                    //           text: 'Selected Location ID: ',
                    //           style: const TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 16.0,
                    //             color: Colors
                    //                 .black, // You can specify the color if needed
                    //           ),
                    //           children: [
                    //             TextSpan(
                    //               text: _selectedLocationId ?? 'None',
                    //               style: const TextStyle(
                    //                 fontWeight: FontWeight
                    //                     .normal, // Change the style for the location name
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
                            _selectedLocationId == null
                                ? Icons.info_outline
                                : Icons.info,
                            color: _selectedLocationName == null
                                ? Colors.grey
                                : Colors.black,
                            size: 20.0,
                          ),
                          const SizedBox(width: 10.0),
                          Text("Select New Sublocation Name",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: _selectedLocationId == null
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                color: _selectedLocationId == null
                                    ? Colors.grey
                                    : Colors.black,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    TextField(
                      enabled: _selectedLocationName != null,
                      controller: _sublocationController,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {},
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50),
                      ],
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: _selectedLocationId != null,
                        alignLabelWithHint: true,
                        hintText: _selectedLocationId == null
                            ? 'Select a location first'
                            : 'Enter Sublocation Name',
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
                    final sublocationName = _sublocationController.text;
                    if (_selectedLocationName != null &&
                        sublocationName.isNotEmpty) {
                      _showConfirmationDialog(_selectedLocationId!,
                          sublocationName, _selectedLocationName!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text(
                                'Please select a location and enter a sublocation name')),
                      );
                    }
                  },
                  child: const Text('Add Sublocation'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SublocationAlertDialogBox extends StatefulWidget {
  final String locationId;
  final String locationName;
  final String sublocationName;
  SublocationAlertDialogBox({
    super.key,
    required this.locationId,
    required this.locationName,
    required this.sublocationName,
  });

  @override
  State<SublocationAlertDialogBox> createState() =>
      _SublocationAlertDialogBoxState();
}

class _SublocationAlertDialogBoxState extends State<SublocationAlertDialogBox> {
  final LocationsDataService _locationsDataService = LocationsDataService();
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: const Text('Confirm Sublocation'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Are you sure you want to add this new sublocation:'),
          const SizedBox(height: 20.0),
          Center(
            child: Text(widget.sublocationName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0)),
          ),
          const SizedBox(height: 20.0),
          RichText(
              text: TextSpan(
            text: 'To the location: ',
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: widget.locationName,
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
                      //     'Error adding sublocation'); // remove this later
                      await _locationsDataService.addSublocation(
                          widget.locationId, widget.sublocationName);
                    } catch (e) {
                      print('Error adding sublocation: $e');

                      Navigator.of(context).popUntil(
                          (route) => route.isFirst); // final response =
                      ToastService.showCustomSnackBar(
                        context: context,
                        content: const Text('Failed to add location:'),
                        leading: const Icon(
                          Icons.error,
                          color: Colors.black,
                        ),
                      );
                      return;
                    } finally {
                      setState(() {
                        isSubmitting = false;
                      });
                    }

                    Navigator.of(context)
                        .popUntil((route) => route.isFirst); // final response =
                    // print('Response: $response');
                    ToastService.showLocationAddedSnackBar(context);
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
