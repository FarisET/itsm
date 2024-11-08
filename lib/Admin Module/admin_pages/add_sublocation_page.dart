import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:safify/User%20Module/providers/location_provider.dart';
import 'package:safify/User%20Module/providers/sub_location_provider.dart';
import 'package:safify/api/locations_data_service.dart';
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
  String _searchQuery = '';
  bool isLocationDropdownSelected = false;

  @override
  void dispose() {
    _sublocationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProviderClass>(context, listen: false)
        .SyncDbAndFetchLocations();
  }

  void _refreshLocations() {
    Provider.of<LocationProviderClass>(context, listen: false)
        .SyncDbAndFetchLocations();
    setState(() {});
  }

  void _onLocationSelected(String? locationId) {
    if (locationId != null) {
      setState(() {
        // Reset state before fetching new sublocations
        isLocationDropdownSelected = false;
        _selectedLocationId = locationId; // Update selected location ID
      });

      // Clear any existing sublocations
      Provider.of<SubLocationProviderClass>(context, listen: false)
          .subLocations = null;

      // Fetch new sublocations for the selected location
      Provider.of<SubLocationProviderClass>(context, listen: false)
          .getSubLocationPostData(locationId)
          .then((_) {
        setState(() {
          isLocationDropdownSelected =
              true; // Enable display after loading completes
        });
      });
    }

    // Clear sublocation field and dismiss keyboard
    _sublocationController.clear();
    FocusScope.of(context).unfocus();
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
          onLocationAdded: _refreshLocations,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationsProvider = Provider.of<LocationProviderClass>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).secondaryHeaderColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Sub Location",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 10.0),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.location_solid,
                                    color: Colors.black,
                                    size: 20.0,
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    "Select Location",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            DropdownMenu(
                                inputDecorationTheme: InputDecorationTheme(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
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
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )),
                                ),
                                expandedInsets:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                requestFocusOnTap: true,
                                menuHeight:
                                    MediaQuery.sizeOf(context).height * 0.3,
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
                                    isLocationDropdownSelected = true;
                                  });
                                  _sublocationController.clear();
                                  _onLocationSelected(_selectedLocationId);
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
                                  ...locationsProvider.allLocations!
                                      .map((location) {
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
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: _selectedLocationName ?? 'None',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 40.0),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
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
                                      Text("Sub Location Name",
                                          style: TextStyle(
                                            fontWeight:
                                                _selectedLocationId == null
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                            color: _selectedLocationId == null
                                                ? Colors.grey
                                                : Theme.of(context)
                                                    .secondaryHeaderColor,
                                          )),
                                    ],
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        final sublocationName =
                                            _sublocationController.text;
                                        if (_selectedLocationName != null &&
                                            sublocationName.isNotEmpty) {
                                          _showConfirmationDialog(
                                              _selectedLocationId!,
                                              sublocationName,
                                              _selectedLocationName!);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              duration: Duration(seconds: 3),
                                              content: Text(
                                                  'Please enter a name first'),
                                              backgroundColor: Colors.redAccent,
                                            ),
                                          );
                                        }
                                      },
                                      child: Text('Add +'))
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            TextField(
                              enabled: _selectedLocationName != null,
                              controller: _sublocationController,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50),
                              ],
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: _selectedLocationId != null,
                                alignLabelWithHint: true,
                                hintText: _selectedLocationId == null
                                    ? 'Select a location first'
                                    : 'Enter sub location name',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
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
                            const SizedBox(height: 20.0),
                            if (isLocationDropdownSelected)
                              Expanded(
                                child: Consumer<SubLocationProviderClass>(
                                  builder:
                                      (context, SublocationProvider, child) {
                                    if (SublocationProvider.subLocations ==
                                        null) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (SublocationProvider
                                        .allSubLocations!.isEmpty) {
                                      return const Center(
                                        child:
                                            Text('No sub locations available.'),
                                      );
                                    }

                                    final filteredLocations =
                                        SublocationProvider.subLocations!
                                            .where((location) => location
                                                .sublocationName
                                                .toLowerCase()
                                                .contains(
                                                    _searchQuery.toLowerCase()))
                                            .toList();

                                    return filteredLocations.isEmpty
                                        ? const Center(
                                            child: Text(
                                                'No matching sub locations.'),
                                          )
                                        : Scrollbar(
                                            thumbVisibility: true,
                                            child: ListView.builder(
                                              itemCount:
                                                  filteredLocations.length,
                                              itemBuilder: (context, index) {
                                                final location =
                                                    filteredLocations[index];
                                                return ListTile(
                                                  title: Text(
                                                      location.sublocationName),
                                                  onTap: () {
                                                    SublocationProvider
                                                        .setSubLocationType(
                                                            location
                                                                .sublocationName);
                                                  },
                                                  trailing: Row(
                                                    mainAxisSize: MainAxisSize
                                                        .min, // To make sure the Row doesn't take up extra space
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.edit_outlined,
                                                            color: Colors.blue),
                                                        onPressed: () {
                                                          showEditSubLocationModal(
                                                              context,
                                                              location
                                                                  .sublocationId,
                                                              location
                                                                  .location_id,
                                                              location
                                                                  .sublocationName);
                                                        },
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                            Icons
                                                                .delete_outline_outlined,
                                                            color: Colors
                                                                .red), // Delete icon
                                                        onPressed: () {
                                                          _showDeleteConfirmationDialog(
                                                              context,
                                                              location
                                                                  .sublocationId,
                                                              SublocationProvider);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  selected: SublocationProvider
                                                          .selectedSubLocation ==
                                                      location.sublocationName,
                                                );
                                              },
                                            ),
                                          );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   width: double.infinity,
                      //   height: 50,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10.0),
                      //       ),
                      //     ),
                      //     onPressed: () {
                      //       final sublocationName = _sublocationController.text;
                      //       if (_selectedLocationName != null &&
                      //           sublocationName.isNotEmpty) {
                      //         _showConfirmationDialog(_selectedLocationId!,
                      //             sublocationName, _selectedLocationName!);
                      //       } else {
                      //         ScaffoldMessenger.of(context).showSnackBar(
                      //           const SnackBar(
                      //               duration: Duration(seconds: 1),
                      //               content: Text(
                      //                   'Please select a location and enter a sub location name')),
                      //         );
                      //       }
                      //     },
                      //     child: const Text('Add Sub Location'),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showEditSubLocationModal(BuildContext context, String subLocationId,
      String locationId, String currentName) {
    final TextEditingController nameController =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.only(top: 100),
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Consumer<SubLocationProviderClass>(
                builder: (context, SublocationProvider, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Sub Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Current Name: $currentName',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'New sublocation name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              String newLocationName =
                                  nameController.text.trim();
                              if (newLocationName.isNotEmpty) {
                                try {
                                  await SublocationProvider.updateSubLocation(
                                      subLocationId,
                                      locationId,
                                      newLocationName);
                                  Navigator.of(context).pop();
                                  _refreshLocations();
                                  FocusScope.of(context).unfocus();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    content: const Text('Sub Location Updated'),
                                    duration: const Duration(seconds: 3),
                                  ));
                                } catch (error) {
                                  Navigator.of(context).pop();

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor: Colors.redAccent,
                                    content: Text('Error: $error'),
                                    duration: const Duration(seconds: 3),
                                  ));
                                }
                                setState(() {}); // Rebuild widget after update
                              }
                            },
                            child: SublocationProvider.isLoading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Text('Update'),
                          )
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String locationId,
      SubLocationProviderClass locationProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this sub location?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                // Call the delete function from the provider
                try {
                  await locationProvider.deleteSubLocation(locationId);
                  Navigator.of(context).pop(); // Close the dialog
                  _refreshLocations();
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    content: const Text('Sub Location Deleted'),
                    duration: const Duration(seconds: 3),
                  ));
                } catch (error) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text('Error: $error'),
                    duration: const Duration(seconds: 3),
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class SublocationAlertDialogBox extends StatefulWidget {
  final String locationId;
  final String locationName;
  final String sublocationName;
  final VoidCallback onLocationAdded;

  SublocationAlertDialogBox(
      {super.key,
      required this.locationId,
      required this.locationName,
      required this.sublocationName,
      required this.onLocationAdded,
      required});

  @override
  State<SublocationAlertDialogBox> createState() =>
      _SublocationAlertDialogBoxState();
}

class _SublocationAlertDialogBoxState extends State<SublocationAlertDialogBox> {
  final LocationsDataService _locationsDataService = LocationsDataService();
  bool isSubmitting = false;
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message.replaceFirst('Exception: ', '')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: const Text('Confirm department'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Are you sure you want to add this new department:'),
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
                      FocusScope.of(context).unfocus();
                      widget.onLocationAdded();
                    } catch (e) {
                      print('Error adding department: $e');

                      _showErrorDialog(e.toString());

                      return;
                    } finally {
                      setState(() {
                        isSubmitting = false;
                      });
                    }

                    Navigator.of(context).pop();
                    ToastService.showDepartmentAddedSnackBar(context);
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
                              'Add',
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
