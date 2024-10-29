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
    Provider.of<LocationProvider>(context, listen: false)
        .SyncDbAndFetchLocations();
  }

  void _refreshLocations() {
    Provider.of<LocationProvider>(context, listen: false)
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
    final locationsProvider = Provider.of<LocationProvider>(context);
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
            "Add Department",
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
              height: MediaQuery.of(context).size.height * 0.6,
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
                                  Text("New Department Name",
                                      style: TextStyle(
                                        fontWeight: _selectedLocationId == null
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                        color: _selectedLocationId == null
                                            ? Colors.grey
                                            : Theme.of(context)
                                                .secondaryHeaderColor,
                                      )),
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
                                    : 'Enter department name',
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
                                  builder: (context, locationProvider, child) {
                                    if (locationProvider.subLocations == null) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (locationProvider
                                        .allSubLocations!.isEmpty) {
                                      return const Center(
                                        child:
                                            Text('No departments available.'),
                                      );
                                    }

                                    final filteredLocations = locationProvider
                                        .subLocations!
                                        .where((location) => location
                                            .sublocationName
                                            .toLowerCase()
                                            .contains(
                                                _searchQuery.toLowerCase()))
                                        .toList();

                                    return filteredLocations.isEmpty
                                        ? const Center(
                                            child: Text(
                                                'No matching departments.'),
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
                                                    locationProvider
                                                        .setSubLocationType(
                                                            location
                                                                .sublocationName);
                                                  },
                                                  selected: locationProvider
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
                                        'Please select a location and enter a department name')),
                              );
                            }
                          },
                          child: const Text('Add Department'),
                        ),
                      ),
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
