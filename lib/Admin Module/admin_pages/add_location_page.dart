import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for LengthLimitingTextInputFormatter
import 'package:safify/api/locations_data_service.dart';
import 'package:safify/services/toast_service.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({super.key});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _showConfirmationDialog(String locationName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogBox(
          locationName: locationName,
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
          title: const Text('Add Location'),
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
                              CupertinoIcons.location_solid,
                              color: Colors.black,
                              size: 20.0,
                            ),
                            const SizedBox(width: 10.0),
                            Text("New Location Name",
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
                        controller: _locationController,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'New Location Name',
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
                    final locationName = _locationController.text;
                    if (locationName.isNotEmpty) {
                      _showConfirmationDialog(locationName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text('Please enter a location name')),
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
    );
  }
}

class AlertDialogBox extends StatefulWidget {
  final String locationName;
  AlertDialogBox({
    super.key,
    required this.locationName,
  });

  @override
  State<AlertDialogBox> createState() => _AlertDialogBoxState();
}

class _AlertDialogBoxState extends State<AlertDialogBox> {
  final LocationsDataService _locationsDataService = LocationsDataService();
  bool isSubmitting = false;

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
                    // Handle the confirmation action
                    // await Future.delayed(const Duration(seconds: 1));

                    try {
                      // throw Exception(
                      //     'Error adding location'); // remove this later

                      await _locationsDataService
                          .addLocation(widget.locationName);
                    } catch (e) {
                      print('Error adding location: $e');

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
                      setState(() {
                        isSubmitting = false;
                      });
                      return;
                    }

                    setState(() {
                      isSubmitting = false;
                    });
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
