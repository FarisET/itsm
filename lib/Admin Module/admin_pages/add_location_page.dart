import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for LengthLimitingTextInputFormatter
import 'package:provider/provider.dart';
import 'package:safify/User%20Module/providers/location_provider.dart';
import 'package:safify/api/locations_data_service.dart';
import 'package:safify/services/toast_service.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({super.key});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  final TextEditingController _locationController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).fetchLocations();
    _locationController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _locationController.text;
    });
  }

  void _showConfirmationDialog(String locationName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogBox(
          locationName: locationName,
          onLocationAdded: _refreshLocations, // Call refresh function
        );
      },
    );
  }

  // New function to refresh locations list after adding a new location
  void _refreshLocations() {
    Provider.of<LocationProvider>(context, listen: false)
        .SyncDbAndFetchLocations();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            "Add Location",
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
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              Icon(CupertinoIcons.location_solid,
                                  color: Colors.black, size: 20.0),
                              SizedBox(width: 10.0),
                              Text(
                                "New Location Name",
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          TextField(
                            controller: _locationController,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              fillColor: Colors.white,
                              filled: true,
                              labelText: 'New Location Name',
                              labelStyle: const TextStyle(
                                fontSize: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 20.0),

                          // ListView for displaying fetched locations with search functionality
                          Expanded(
                            child: Consumer<LocationProvider>(
                              builder: (context, locationProvider, child) {
                                if (locationProvider.allLocations == null) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (locationProvider.allLocations!.isEmpty) {
                                  return const Center(
                                    child: Text('No locations available.'),
                                  );
                                }

                                final filteredLocations = locationProvider
                                    .allLocations!
                                    .where((location) => location.locationName
                                        .toLowerCase()
                                        .contains(_searchQuery.toLowerCase()))
                                    .toList();

                                return filteredLocations.isEmpty
                                    ? const Center(
                                        child: Text('No matching locations.'),
                                      )
                                    : Scrollbar(
                                        thumbVisibility: true,
                                        child: ListView.builder(
                                          itemCount: filteredLocations.length,
                                          itemBuilder: (context, index) {
                                            final location =
                                                filteredLocations[index];
                                            return ListTile(
                                              title:
                                                  Text(location.locationName),
                                              onTap: () {
                                                locationProvider.setLocation(
                                                    location.locationName);
                                              },
                                              selected: locationProvider
                                                      .selectedLocation ==
                                                  location.locationName,
                                            );
                                          },
                                        ),
                                      );
                              },
                            ),
                          ),

                          const SizedBox(height: 20.0),

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
                                final locationName = _locationController.text;
                                if (locationName.isNotEmpty) {
                                  _showConfirmationDialog(locationName);
                                  FocusScope.of(context)
                                      .unfocus(); // Dismiss the keyboard
                                  _locationController.clear(); // Clear input
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 1),
                                      content:
                                          Text('Please enter a location name'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Add Location'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AlertDialogBox extends StatefulWidget {
  final String locationName;
  final VoidCallback onLocationAdded;

  AlertDialogBox({
    super.key,
    required this.locationName,
    required this.onLocationAdded,
  });

  @override
  State<AlertDialogBox> createState() => _AlertDialogBoxState();
}

class _AlertDialogBoxState extends State<AlertDialogBox> {
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
      title: const Text('Confirm Location'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Are you sure you want to add this new location:'),
          const SizedBox(height: 10.0),
          Text(widget.locationName,
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
                      await _locationsDataService
                          .addLocation(widget.locationName);
                      widget.onLocationAdded(); // Call callback to refresh
                    } on Exception catch (e) {
                      setState(() {
                        isSubmitting = false;
                      });
                      _showErrorDialog(e.toString());
                      return;
                    }

                    setState(() {
                      isSubmitting = false;
                    });

                    Navigator.of(context).pop();
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Add',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
